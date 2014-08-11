module HbirdNotification
  class NotificationMailer < ActionMailer::Base
    default from: Engine.config_or_default('mail_sender')
  
    def notify_user(address, mail)
      mail(to: address, subject: mail['subject']) do |format|
        format.text { render text: mail['body'] }
      end
    end
  end
end
