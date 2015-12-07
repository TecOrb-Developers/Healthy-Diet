# Q: How is this related to Track?

# A supplement-use is a record whether a user took a supplement on a given day
# Used: when a user clicks "yes" or "no" when asked if they took a supplement on a given day.
# if they skip a week, no records.  Perhaps not daily.  User intervention table for dosage table.
#   two times daily or two times per week.  record once-a-day.  taken as plan. 
#   issues: user's timezone.  UTC time, localtime.  11:59 or 12:01.  User's localtime.  Don't know their timezone?? 
# push notification: log for that date.  when to send a notification?  for local times.  opt-in or opt-out.  

class InterventionUse < ApplicationModel 
 belongs_to :intervention_trial
 belongs_to :intervention
 belongs_to :user

 validates  :on_date, date: true, presence: true
 validates  :taken, boolean: true
 # validates :comments, short_string: true
 # before_save :update_record

 # def update_record
 # 	self.pending = true
 # end	
end

