class ApplePushWorker
	include Sidekiq::Worker

  def perform(device_token, message, badges)
             

    pusher = Grocer.pusher(
      certificate: Rails.root.join('SlotilityProduction.pem'),        # required
      passphrase:  "SlotilityApp",                       # optional
      gateway:     "gateway.push.apple.com", # optional; See note below.
      port:        2195,                     # optional
      retries:     3                         # optional
    )
    
    notification = Grocer::Notification.new(
      :device_token => device_token.to_s,
      :alert =>  message,
      :badge => badges,
      :sound => "siren.aiff",         # optional
      :expiry => Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
      :identifier => 1234,                 # optional
      :content_available => true                  # optional; any truthy value will set 'content-available' to 1
      )
     pusher.push(notification)
    
  end
end