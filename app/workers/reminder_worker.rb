require 'scheduler'
class ReminderWorker
  include Sidekiq::Worker
  include Scheduler
  
  def perform()
  	puts "Hi"
    send_notification
  end  
  
end
	