require 'rubygems'
require 'bundler/setup'
require 'locomotive_plugins'

module HbirdNotification
  class HbirdNotification
    include Locomotive::Plugin

    def config_template_file
      File.join(File.dirname(__FILE__), 'hbird_notification', 'config.html')
    end
  end
end
