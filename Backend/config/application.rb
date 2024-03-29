require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Seg3502Livrable3
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true

    # Add classes available in the "lib" folder
    config.autoload_paths << Rails.root.join("lib")
  end
end
