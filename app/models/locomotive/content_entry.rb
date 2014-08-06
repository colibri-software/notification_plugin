require_dependency Locomotive::Engine.root.join('app', 'models', 'locomotive', 'content_entry').to_s

module Locomotive
  class ContentEntry
    after_save :debug

    def debug *args
      puts "\n=========================================="
      pp args
      puts "\n=========================================="
    end
  end
end
