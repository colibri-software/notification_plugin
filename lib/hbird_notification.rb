require 'rubygems'
require 'bundler/setup'
require 'locomotive_plugins'
require 'hbird_notification/config'
require 'hbird_notification/notification_mailer'

module HbirdNotification
  class HbirdNotification
    include Locomotive::Plugin

    after_plugin_setup :set_config

    def self.plugin_loaded
      Locomotive::ContentEntry.class_eval do

        after_save do |document|
          notification_callback(document)
        end

        after_create do |document|
          notification_callback(document, :create)
        end

        before_destroy do |document|
          notification_callback(document, :destroy)
        end

        def notification_callback(document, action = :save)
          plugin_object = Thread.current[:site].enabled_plugin_objects_by_id['hbird_notification']
          return unless plugin_object

          mail_generation_script = ::HbirdNotification::Config.hash[:mail_generation_script]
          return unless  mail_generation_script

          context = plugin_object.js3_context
          context['document'] = document.as_document
          context['content_type'] = document.content_type
          context['action'] = action.to_s
          context['email_user'] = lambda{|this,address,subject,body|
            ::HbirdNotification::NotificationMailer.notify_user(address, subject, body).deliver
          }
          context.eval(mail_generation_script)
        end

      end
    end

    def config_template_file
      File.join(File.dirname(__FILE__), 'hbird_notification', 'config.html')
    end

    private

    def set_config
      Config.hash = config
    end
  end
end
