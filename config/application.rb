require_relative 'boot'

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SoilsAgWx
  class Application < Rails::Application
    config.load_defaults 5.0

    config.time_zone = 'Central Time (US & Canada)'

  end
end
