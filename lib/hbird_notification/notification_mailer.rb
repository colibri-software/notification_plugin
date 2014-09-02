module HbirdNotification
  class NotificationMailer < ActionMailer::Base

    def notify_user(address, subject, body)
      mail(from: Config.hash[:mail_sender], to: address, subject: subject) do |format|
        format.text { render text: body }
      end
    end
  end
end
