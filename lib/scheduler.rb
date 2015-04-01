module Scheduler
  
  def send_notification
  	puts 'Hello... Clock'
    Trial.active.each do |trial|
    	users = trial.users
    	remind(users) unless users.empty?
    end	
  end 

  def remind users
  	users.each do |user|
  		intervention_trails = user.intervention_trials
      find_supplements(user, intervention_trails) unless intervention_trails.empty?
  	end	
  end	
  
  def find_supplements user, intervention_trails
  	intervention_trails.each do |intervention_trail|
  		intervention_use = InterventionUse.where("intervention_trial_id = ? and on_date = ?", intervention_trail.id, Date.today).first
      if intervention_use.nil? 
        intervention_use = InterventionUse.create(intervention_trial_id: intervention_trail.id, on_date: Date.today, taken: false) 
      end
      msg = "Did you take your #{intervention_trail.intervention.name} on #{intervention_use.on_date}?"
      create_notification(msg, user)
  	end	
  end

  def create_notification message, user
    user.devices.each do |device|
    	#badges = notification_count(user)
    	ApplePushWorker.perform_async(device.device_token, message, 1)
    end 
  end	

  # def notification_count user 
  # 	 Intervention.find(user.intervention_trials.pluck(:intervention_id))
  #   count = InterventionUse.where("intervention_trial_id IN (?) and pending = ?", user.intervention_trials, false).count || 1
  #   return count
  # end  
  
end



 