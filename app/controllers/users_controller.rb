class UsersController < ApplicationController

  def login
  	user = User.find_by(email: params[:user][:email])
 	  if user && user.valid_password?(params[:user][:password])
      sign_in :user, user 
      profile = user.profile
      first_name = ""; last_name = ""
      unless profile.nil?
        first_name = profile.first_name
        last_name = profile.last_name
      end  
      trails = user.trials
      status = false
      status = ((Time.now.to_date - trails.last.start_date).to_i) >= 0 if trails.present?
      over = ((Time.now.to_date - trails.last.end_date).to_i) >= 0 if trails.present?
      Device.add_token(user, params[:user][:device_token]) if params[:user][:device_token].present?
      render json: {
 	  		             response_code: 200,
 	  		             response_message: "You've logged in successfully.",
 	  		             id: user.id,
                     email: user.email,
                     first_name: first_name ,
                     last_name: last_name ,
                     is_active: status,
                     settings: user.settings,
                     is_subscribed: trails.present?,
                     is_over: over
                   }
 	  else
 	  	render json: {
 	  		             response_code: 500,
 	  		             response_message: "Unauthorised access."
                   }
 	  end	             
  end

  	
  def account
   user = User.find(params[:id])
    if user.valid_password?(params[:user][:current_password])
      if params[:user][:password] != (params[:user][:current_password])
        user.update_attributes(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
        render :json => {
                          :response_code => 200,
                          :response_message => "Password has been updated successfully."             
                        }
      else
        render :json => {
                          :response_code => 500,
                          :response_message => "New Password and current password can't be identical."             
                        }
      end
    else
      render :json => {
                        :response_code => 500,
                        :response_message => "Current password doesn't match."        
                      }
    end        
  end  

  
  def logout
    user = User.find(params[:id])
    if user.devices.find_by(device_token: params[:user][:device_token]).destroy 
       sign_out user
      render json: {
                    response_code: 200,
                    response_message: "You've logged out successfully."
                   }
    end             
  end

  def glance
    page = Hash.new
    page[:title] = "At a Glance"
    page[:body] = '# Feel full = eat less.#  #If you eat foods which move slowly through your stomach, you will feel more full, eat less and maintain a healthier weight.#

   #We need your help.#  #Share your results so we learn which foods work best for making you feel full.#

    #Works with any diet.#  #Regardless of what you eat, use SLOtility to eat less and feel more full.#

    #Beyond weight loss.#  #Sixteen foods to help reduce your risk of diabetes, high blood pressure, and heart disease.# 
    
    #Pay what you wish.# #We let you decide what SLOtility is worth to you.#
    
    #Who are we?# #Our team is based in Philadelphia and the creator, Frank Duffy, is a nutritionist and health-food researcher.#'
   
    render json: {
                    response_code: 200,
                    page: page,
                    page_detail: Page.find(6).as_json(except: [:id, :created_at, :updated_at])
                 }
  end 

  def steps
    render json: {
                    response_code: 200,
                    page: Page.find(7).as_json(except: [:id, :created_at, :updated_at])
                 }
  end 

  def introduction
    render json: {
                    response_code: 200,
                    page: Page.find(9).as_json(except: [:id, :created_at, :updated_at])
                 }
  end  

  def principles
    render json: {
                    response_code: 200,
                    page: Page.find(3).as_json(except: [:id, :created_at, :updated_at]),
                    principle: Principle.all.order("id ASC").as_json(except: [:id, :created_at, :updated_at])
                 }
  end  
  

  def feedback
    @user = User.find_by(email: params[:user][:email])
    @user.send_feedback(params[:user])
    render json: {
                    response_code: 200,
                    response_message: "Your feedback has been sent successfully."
                 }
  end 

  def policy
    page = Page.find(4)
    page.attributes.except("created_at", "updated_at", "id", "body").merge!(:body => page.body.gsub!(';', ''))   
    render json: {
                    response_code: 200,
                    response_message: "Your feedback has been sent successfully.",
                    privacy_policy: page
                 }
  end  

  def update_settings
    @user = User.find(params[:id])
    if @user and @user.update_attributes(settings: params[:user][:settings])
      render json: {
                    response_code: 200,
                    response_message: "Settings has been successfully updated.",
                    settings: @user.settings
                   }
    end               
  end  
  
  def notification
    notifications = Array.new
    msg = "Notification has been successfully fetched."
    user = User.find(params[:id])
    trails = user.trials.last
    int_tra = user.intervention_trials.pluck(:id)
    (trails.start_date..(Date.today)).each_with_index do |date,index|
      notification = {}; array = [] 
      intervention_uses = InterventionUse.where("intervention_trial_id IN (?) and on_date = ?", int_tra, date)
      unless intervention_uses.blank?
        intervention_uses.each do |u|
          array << u.attributes.except("user_id", "intervention_id", "trial_id").merge!(:name => u.intervention_trial.intervention.name, :day => index+1) unless u.pending.eql? true  
        end 
        notification[:day] = index+1
        notification[:date] = date
        notification[:feeds] = array
        notifications << notification
      end      
    end  
    count = notifications.map{|x| x[:feeds].empty?}.uniq
    msg = "No new notifications." if count.first.eql? true && count.length == 1 or notifications.blank?
    render json: {
                    response_code: 200,
                    response_message: msg,
                    notification: notifications
                 }
  end  

  def forgot_password
    user = User.find_by(email: params[:user][:email])
    if user
      user.send_token
      render :json => { :response_code => 200,
                        :response_message => 'You will receive a access code at your email address in a few minutes.'
                      } 
    else
      render :json => { :response_code => 500,
                        :response_message => "Sorry, User doesn't exist in the database."
                      } 
    end   

  end  

  def get_supplements
    interventions = Array.new
    interventionz = Array.new
    supplements = Hash.new
    
    Intervention.order("id ASC").first(13).each{|i| 
      interventionz << i.attributes.except("image").merge!(:picture => intervention_image(i), :diseases => i.diseases.map(&:name).to_sentence.titleize)}
    supplements[:basic] = interventionz
    
    Intervention.order("id ASC").last(16).each{|i| 
      interventions << i.attributes.except("image").merge!(:picture => intervention_image(i), :diseases => i.diseases.map(&:name).to_sentence.titleize)}
    supplements[:extras] = interventions
    
    render :json => { :response_code => 200,
                      :response_message => 'Supplements are fetched successfully.',
                      :supplements => supplements
                    } 
  end  

  def update_password
    user = User.find_by(reset_password_token: params[:user][:reset_password_token])
    if user
      if user.reset_password_sent_at > Time.zone.now + 8.hours
          user.update_attributes(reset_password_token: nil)
          render :json => { 
                            :response_code => 500,
                            :response_message => 'Your password reset code has been expired.'
                          } 
      else 
        user.update_attributes(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation], reset_password_token: nil)
        render :json => { 
                          :response_code => 200,
                          :response_message => 'Password has been reset successfully.'
                        }  
        
      end
    else
      render :json => { 
                        :response_code => 500,
                        :response_message => "Access code doesn't exist in the database."
                      }
    end  
  end  



  def dashboard
    user = User.find(params[:id])
    dash_data = {}
    datas = Array.new
    trails = user.trials.last
    unless trails.nil?
      time = (Time.now.to_date - trails.start_date).to_i
      int_tra = user.intervention_trials.pluck(:id)
      y = []
      user.intervention_trials.each do |x| 
        y << x.attributes.merge(:supplement_name => x.intervention.title) 
      end  
      dash_data[:supplements] = y.as_json(only: [:supplement_name])
      dash_data[:days_left] = time
      dash_data[:is_active] = time >= 0
      (trails.start_date..trails.end_date).each do |date|
        data = {}
        array = []
        data[:date] = date
        intervention_uses = InterventionUse.where("intervention_trial_id IN (?) and on_date = ?", int_tra, date)
        intervention_uses.each do |u|
          array << u.attributes.except("user_id", "intervention_id", "trial_id").merge!(:name => u.intervention_trial.intervention.name) 
        end  
        data[:status] = array
        data[:colour] = check_status(intervention_uses.map(&:taken)) 
        datas << data
      end  
      dash_data[:dates] = datas
    end
    render json: {
                    response_code: 200,
                    response_message: "All records has been fetched.",
                    records: dash_data
                    
                 }
  end  

  def profile
    user = User.find(params[:id])
    variables = Array.new
    Variable.last(11).each do |v|
      vari = UsersVariables.where(user_id: user.id, variable_id: v.id).last
      if vari
        variables << vari.attributes.except("created_at", "updated_at", "value2", "id", "user_id", "variable_id").merge(:name => vari.variable.name, value2: vari.value2 || "")
      end  
    end  
    if user
      render json: {
                    response_code: 200,
                    response_message: "Your profile has been successfully fetched.",
                    profile: user.profile.attributes.merge!(variable: variables)
                   }

    end  
  end 

  def notification_count
    user = User.find(params[:id])
    trails = user.trials.last
    int_tra = user.intervention_trials.pluck(:id)    
    count = InterventionUse.where("intervention_trial_id IN (?) and pending = ?", int_tra, false).count || 0
    render json: {
                    response_code: 200,
                    count: count
                 }
   
  end  

  def acknowledge_supplements
    intervention_use = InterventionUse.find(params[:id])
    if intervention_use && intervention_use.update_attributes(taken: params[:taken], pending: true)
       render json: {
                      response_code: 200,
                      response_message: "Your status has been successfully updated."
                    }
    else
       render json: {
                    response_code: 500,
                    response_message: "Unable to update."
                   }

    end  
  end  

  private 
    def user_params
      params.require(:user).permit!
    end

    def check_status array
      return colour = "" if array.empty?
      c = array.uniq
      if c.length == 2
        colour = "Yellow"
      elsif c.length == 1 and c[0] == true
        colour = "Green"     
      else
        colour = "Red" 
      end 
      return colour    
    end  

  def intervention_image intervention
    image = (intervention.image.url == "/intervention_images/placeholder_name") ? ("http://SLOtility.herokuapp.com/assets/intervention/#{intervention.name}.png") : "http://SLOtility.herokuapp.com/"+intervention.image.url
    return image
  end

end
