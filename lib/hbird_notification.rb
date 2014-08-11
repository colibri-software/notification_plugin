require 'rubygems'
require 'bundler/setup'
require 'locomotive_plugins'
require 'hbird_notification/engine'
require 'execjs'

module HbirdNotification
  class HbirdNotification
    include Locomotive::Plugin

    before_page_render :set_config

    def self.users_list
      # FIXME: figure out a way to cache it since it can be really slow fetch each time...
      IdentityPlugin::Identity.all.collect{ |user| { name: user.name, email: user.email } }
    end

    def initialize
      @@injected ||= false
      return if @@injected

      Locomotive::ContentEntry.class_eval do
        after_save do |document|
          mail_generation_script = Engine.config_or_default('mail_generation_script')
          next if mail_generation_script == nil

          # // generate function takes users (array of {name: 'Foo', email: 'foo@example.com'})
          # // and changed document object (ruby code: document.as_document) execute the javascript
          # // then return a javascript object with structure:
          # // mails
          # //  |- 'foo@example.com'
          # //  |   |- subject: 'Mail Subject'
          # //  |   `- body: 'Mail body... with document change information'
          # //  `- 'bar@example.com'
          # //      |- subject: 'Mail Subject (can be different one based on javascript)'
          # //      `- body: 'Mail body... with document change information (can be different)'
          # // which convert to ruby hash
          # // { 'foo@example.com' => { subject: 'Mail Subject', body: 'Mail body... with document change information' }, ... }
          # function generate(users, document) {
          #   var mails = {};
          #   users.forEach(function(user) {
          #     var mail = {};
          #     mail.subject = 'Notification for ' + user.name + ': Document Change';
          #     mail.body = 'Document Changed: ' + JSON.stringify(document);
          #
          #     mails[user.email] = mail;
          #   });
          #
          #   return mails;
          # }
          context = ExecJS.compile mail_generation_script
          mails = context.call 'generate', ::HbirdNotification::HbirdNotification.users_list, document.as_document

          mails.each do |address, mail|
            ::HbirdNotification::NotificationMailer.notify_user(address, mail).deliver
          end
        end
      end

      @@injected = true
    end

    def self.rack_app
      Engine
    end

    def config_template_file
      File.join(File.dirname(__FILE__), 'hbird_notification', 'config.html')
    end

    private
    def set_config
      mounted_rack_app.config_hash = config
    end
  end
end
