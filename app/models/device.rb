class Device < ActiveRecord::Base
  belongs_to :user
  
  def self.add_token user, token
    device = self.find_by(device_token: token)	
    if device
        device.update_attribute(:user_id, user.id)
    else
    	self.create!(user_id: user.id, device_token: token)
    end 
  end	
end
