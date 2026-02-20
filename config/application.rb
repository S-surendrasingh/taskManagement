require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module TaskManager
  class Application < Rails::Application
    config.load_defaults 6.1

    # Full stack is required for the admin UI (sessions, views, flash).
    # API controllers still inherit from ActionController::API.
    # config.api_only = false
  end
end
