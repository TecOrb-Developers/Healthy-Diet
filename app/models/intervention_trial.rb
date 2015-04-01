# A supplement trial is where a user commits to taking an intervention for a period of time. 

class InterventionTrial < ApplicationModel
  belongs_to :user
  belongs_to :intervention
  belongs_to :trial
  has_many :intervention_uses
end

# Used: when presenting daily questions for which supplements a user has taken today/yesterday.  
# Treatment plan.  Treatment line item?  Supplement taking for whole trial.  user.

