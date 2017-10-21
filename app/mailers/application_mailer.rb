class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
  def recv_email(user, sender, message)
    @user = user
    @sender = sender
    @message = message
    mail(to: @user.email, subject: 'Your account has new Email message!')
  end
  def seen_email(user, recipient, message)
    @user = user
    @recipient = recipient
    @message = message    
    mail(to: @user.email, subject: 'Your sent-email message was seen!')
  end
end
