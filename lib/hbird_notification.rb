require 'rubygems'
require 'bundler/setup'
require 'locomotive_plugins'
require 'hbird_notification/engine'

module HbirdNotification
  class HbirdNotification
    include Locomotive::Plugin

    before_page_render :set_config

    def initialize
      Locomotive::ContentEntry.class_eval do
        after_save do |document|
          puts "\n=========================================="
          pp document
          puts "\n=========================================="
        end
      end
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
