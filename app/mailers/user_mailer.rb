class UserMailer < ApplicationMailer
  default from: 'propertymanagement.atv@gmail.com'

  def welcome_email(user,inquiry)
    @user = user
    @inquiry = inquiry
    @url = 'https://localhost:3000'
    mail(to: @user.email_id, subject: 'Response to your inquiry has been posted')
  end
end
