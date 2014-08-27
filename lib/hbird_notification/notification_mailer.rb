module HbirdNotification
  class NotificationMailer < ActionMailer::Base
    default from: Config.hash[:mail_sender]

    def notify_user(address, subject, body)
      mail(to: address, subject: subject) do |format|
        format.text { render text: body }
      end
    end
  end
end
