module HbirdNotification
  class Engine < ::Rails::Engine
    isolate_namespace HbirdNotification

    def self.config_hash=(hash)
      @config_hash = hash
    end

    def self.config_hash
      @config_hash ||= {}
    end

    def self.config_or_default(key)
      defaults = {
      }
      hash = defaults.merge(config_hash)
      hash[key]
    end
  end
end
