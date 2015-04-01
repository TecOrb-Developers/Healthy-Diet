class UserMailer < ActionMailer::Base
  default from: '"Slotility" <team@slotility.com>'

  def reset_password_mail user
    @user = user
    @user.update_attribute(:reset_password_sent_at, Time.now)
    mail(:to => @user.email, :subject => "Password Reset Instructions")
  end

  def feedback(user, parameters)
  	mail(:to => "support@slo-tility.com", :subject => "Feedback", body: parameters[:body])
  end	
end
