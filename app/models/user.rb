class User < ApplicationModel
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, default: "", presence: true

  has_one :profile
  has_many :variables, :through => :users_variables
  has_many :users_variables, :class_name => UsersVariables
  has_many :tracks, :through => :users_tracks
  has_many :users_tracks, :class_name => UsersTracks
  has_many :trials, :through => :users_trials
  has_many :users_trials, :class_name => UsersTrials
  has_many :intervention_trials, :class_name => InterventionTrial
  has_many :histories, :through => :users_histories
  has_many :users_histories, :class_name => UsersHistories
  has_many :devices, dependent: :destroy
  # validates admin, :boolean


  def send_feedback parameters
    UserMailer.feedback(self, parameters).deliver
  end  

  def send_token
    chars = ("0".."9").to_a 
    password_first = ""
    1.upto(8) { |i| password_first << chars[rand(chars.size-1)]}
    self.update_attribute(:reset_password_token, password_first)
    UserMailer.reset_password_mail(self).deliver
  end 

  def admin?
    self.admin == true
  end

  def save_var(var_name, val1, val2=nil)
    var = Variable.find_by_name(var_name)
    UsersVariables.create(:user_id => self.id, :variable_id => var.id, :value => val1, :value2 => val2) unless var.nil?
  end

  def get_var(var_name)
    var = Variable.find_by_name(var_name)
    return nil if var.nil?
    self.users_variables.where(:variable_id => var.id).last
  end

  def display_name
    return nil unless self.profile && self.profile.display_name.present?
    self.profile.display_name
  end

  #def age
  #  (Time.now - self.profile.birthdate.to_time)/(60*60*24*365)
  #end

  def age
    return nil unless self.profile && self.profile.age.present?
    self.profile.age
  end

  def gender
    return nil unless self.profile && self.profile.gender.present?
    self.profile.gender
  end

  def height
    get_var('height')
  end

  def weight
    get_var('weight')
  end

  def smoke
    get_var('smoke')
  end

  def alcohol
    get_var('alcohol')
  end

  def waist
    get_var('waist_circumference')
  end

  def hip
    get_var('hip_circumference')
  end

  def blood_pressure
    get_var('blood_pressure')
  end

  def blood_sugar
    get_var('blood_sugar')
  end

  def total_cholesterol
    get_var('total_cholesterol')
  end

  def hdl_cholesterol
    get_var('hdl_cholesterol')
  end

  def triglycerides
    get_var('triglycerides')
  end

  def hemoglobin
    get_var('hemoglobin_A1C')
  end

  def bmi
    get_var('bmi')
  end

  def family_history
    self.users_histories.where(history_type: 'family').map(&:disease)
  end

  def disease_history
    self.users_histories.where(history_type: 'disease').map(&:disease)
  end

  def medicine_history
    self.users_histories.where(history_type: 'medicine').map(&:disease)
  end

  def hbp_risk
    get_var('hbp_risk')
  end

  def cvd_risk
    get_var('cvd_risk')
  end

  def diabetes_risk
    get_var('diabetes_risk')
  end
end
