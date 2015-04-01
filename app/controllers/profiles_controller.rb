class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.profile.nil?
      redirect_to new_profile_path
    else
      #redirect_to edit_profiles_path
      @profile = current_user.profile
      render 'profile'  # was: render 'show'  why?  no 'show.html.erb' template.
    end
  end

  def new
    @profile = Profile.new
    render 'profile'
  end

  def create_or_update
    if current_user.profile.nil?
      @profile = Profile.new(profile_params.merge(:user_id => current_user.id))
      if @profile.save
        save_treatment_vars
        save_histories
        calculate_risk_vars
        flash[:notice] = 'Profile created successfully'
        redirect_to risk_assessment_profiles_path
      else
        render 'profile'
      end
    else
      @profile = current_user.profile
      if @profile.update_attributes!(profile_params)
        save_treatment_vars
        save_histories
        calculate_risk_vars
        flash[:notice] = 'Profile updated successfully'
        redirect_to risk_assessment_profiles_path
      else
        render 'profile'
      end
    end
  end

  def edit
    @profile = current_user.profile
    render 'profile'
  end

  def show
    @profile = current_user.profile
  end

  def risk_assessment
    @user = current_user
  end

  def track_selection
    @user = current_user
    UsersTracks.delete_all(:user_id => current_user.id)
    params[:track_selection].each do |track_id|
      UsersTracks.find_or_create_by_user_id_and_track_id(:user_id => current_user.id, :track_id => track_id.to_i)
    end unless params[:track_selection].nil?
    redirect_to supplement_selection_profiles_path
  end

  def supplement_selection
    if params[:supplement_selection].nil?
      @tracks = UsersTracks.where(:user_id => current_user.id).map(&:track)
      if @tracks.blank?
        flash[:notice] = 'You must select one or more tracks for your SLOtility program.'
        redirect_to risk_assessment_profiles_path
        return
      else
        @supplements = Intervention.treatment(@tracks.map(&:disease))
      end
      render 'supplement_selection'
    else
      InterventionTrial.delete_all(:user_id => current_user.id)
      params[:supplement_selection].each do |s_id|
        InterventionTrial.find_or_create_by_user_id_and_intervention_id(:user_id => current_user.id, :intervention_id => s_id.to_i)
      end
      redirect_to dashboard_index_path
    end
  end

  def trial_selection
    @user = current_user
    UsersTrials.find_or_create_by_user_id_and_trial_id(:user_id => current_user.id, :trial_id => params[:trial].to_i)
    redirect_to dashboard_index_path
  end

  private
    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :display_name, :gender, :ethnicity, :age) #:birthdate)
    end

    def save_treatment_vars
      current_user.save_var('weight', params[:weight]) unless params[:weight].blank?
      current_user.save_var('goal_weight', params[:goal_weight]) unless params[:goal_weight].blank?
      current_user.save_var('height', params[:height]) unless params[:height].blank?
      current_user.save_var('waist_circumference', params[:waist_circumference]) unless params[:waist_circumference].blank?
      current_user.save_var('hip_circumference', params[:hip_circumference]) unless params[:hip_circumference].blank?
      current_user.save_var('smoke', params[:smoke]) unless params[:smoke].blank?
      current_user.save_var('blood_pressure', params[:systolic_blood_pressure], params[:diastolic_blood_pressure]) unless (params[:systolic_blood_pressure].blank? || params[:diastolic_blood_pressure].blank?)
      current_user.save_var('blood_sugar', params[:blood_sugar]) unless params[:blood_sugar].blank?
      current_user.save_var('hemoglobin_A1C', params[:hemoglobin_A1C]) unless params[:hemoglobin_A1C].blank?
      current_user.save_var('total_cholesterol', params[:total_cholesterol]) unless params[:total_cholesterol].blank?
      current_user.save_var('hdl_cholesterol', params[:hdl_cholesterol]) unless params[:hdl_cholesterol].blank?
      current_user.save_var('triglycerides', params[:triglycerides]) unless params[:triglycerides].blank?
    end

    def save_histories
      params[:family_history].each do |disease_id|
        UsersHistories.find_or_create_by_history_type_and_user_id_and_disease_id(:history_type => 'family', :user_id => current_user.id, :disease_id => disease_id)
      end unless params[:family_history].blank?

      params[:disease_history].each do |disease_id|
        UsersHistories.find_or_create_by_history_type_and_user_id_and_disease_id(:history_type => 'disease', :user_id => current_user.id, :disease_id => disease_id)
      end unless params[:disease_history].blank?

      params[:medicine_history].each do |disease_id|
        UsersHistories.find_or_create_by_history_type_and_user_id_and_disease_id(:history_type => 'medicine', :user_id => current_user.id, :disease_id => disease_id)
      end unless params[:medicine_history].blank?
    end

    def calculate_bmi(user)
      return nil if (user.height.nil? || user.weight.nil?)
      height = user.height.value * 0.0254 # convert to meters
      weight = user.weight.value * 0.453592 # convert to kg
      return weight / (height * height)
    end

    def calculate_risk_vars
      # calculate bmi
      bmi = calculate_bmi(current_user)
      current_user.save_var('bmi', bmi) unless bmi.nil?

      # setup vars
      age = current_user.age
      sex = (current_user.gender == 'male') ? 0 : 1
      bp = current_user.blood_pressure
      sbp = bp.nil? ? nil : bp.value
      dbp = bp.nil? ? nil : bp.value2
      smoking = current_user.smoke.present? ? current_user.smoke.value : 0
      hbp_history = current_user.family_history.map(&:name).include?('high_blood_pressure') ? 1.5 : 0
      bmi = current_user.bmi && current_user.bmi.value
      diabetes = current_user.disease_history.map(&:name).include?('diabetes')
      diabetes_treated = current_user.medicine_history.map(&:name).include?('diabetes')
      diabetes_family_history = current_user.family_history.map(&:name).include?('diabetes')
      hbp_treated = current_user.medicine_history.map(&:name).include?('high_blood_pressure')
      hdl = current_user.hdl_cholesterol.nil? ? nil : current_user.hdl_cholesterol.value
      tg = current_user.triglycerides.nil? ? nil : current_user.triglycerides.value
      blood_sugar = current_user.blood_sugar.nil? ? nil : current_user.blood_sugar.value

      # calculate hypertension risk
      if (age.present? && sbp.present? && dbp.present? && smoking.present? && bmi.present?)
       hbp_risk = 1-Math.exp(-Math.exp((Math.log(8) - ((age * -0.15641) + (sex * -0.20293) + (sbp * -0.05933) + (dbp * -0.12847) + (smoking * -0.19073) + (hbp_history * -0.16612) + (bmi * -0.03388) + (age * dbp * 0.00162) + 22.94954))/0.87692))
       current_user.save_var('hbp_risk', hbp_risk)
      end

      # calculate cardiovascular risk
      if (age.present? && sbp.present? && smoking.present? && bmi.present?)
        if (sex == 0) # male
          sbp_beta = hbp_treated.present? ? 1.92672 : 1.85508
          cvd_risk = 1-(0.88431 ** Math.exp((((Math.log(age) * 3.11296) + (Math.log(bmi) * 0.79277) + (Math.log(sbp) * sbp_beta) + (smoking * 0.70953) + ((diabetes_treated || diabetes) ? 0.5316 : 0)) - 23.9388)))
          current_user.save_var('cvd_risk', cvd_risk)
        else # female
          sbp_beta = hbp_treated.present? ? 2.88267 : 2.81291
          cvd_risk = 1-(0.94833 ** Math.exp((((Math.log(age) * 2.72107) + (Math.log(bmi) * 0.51125) + (Math.log(sbp) * sbp_beta) + (smoking * 0.61868) + ((diabetes_treated || diabetes) ? 0.77763 : 0)) - 26.0145)))
          current_user.save_var('cvd_risk', cvd_risk)
        end
      end

      # calculate diabetes risk
      if (blood_sugar.present? && blood_sugar >= 126)
        current_user.save_var('diabetes_risk', 100.0)
      elsif (blood_sugar.present? && bmi.present? && hdl.present? && sbp.present? && dbp.present? && tg.present?)
        impaired_fasting_glucose = (blood_sugar >= 100)
        overweight = (bmi >= 25) ? 1 : 0
        obese = (bmi > 30) ? 1 : 0
        low_hdl = ((sex == 0) && (hdl < 40)) ? 1 : (((sex == 1) && (hdl < 50)) ? 1 : 0)
        high_tg = (tg >= 150) ? 1.0 : 0.0
        high_bp = (hbp_treated && (sbp >= 130)) ? 1 : ((!hbp_treated && (dbp >= 85)) ? 1 : 0)
        diabetes_sum = (-5.517 + ((impaired_fasting_glucose ? 1 : 0) * 1.98) + (obese ? 0.92 : (overweight ? 0.30 : 0)) + (low_hdl * 0.94) + (high_tg * 0.58) + (high_bp * 0.50) + ((diabetes_family_history ? 1 : 0) * 0.57))
        diabetes_risk = Math.exp(diabetes_sum) / (1 + Math.exp(diabetes_sum))
        current_user.save_var('diabetes_risk', diabetes_risk)
      end
    end
end
