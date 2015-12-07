# Example: manage_weight or decrease_high_blood_pressure_risk (about 4 instances) 
#  Perhaps holds information relevant to improving how a disease can be managed, or represents possible goals for a user in starting a trial
class Track < ApplicationModel
  belongs_to :disease

  validates :name, text: true, presence: true  
  # has_many :interventions, through :diseases # ADD??
end
