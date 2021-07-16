require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dharmavision
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # https://github.com/romanbsd/heroku-deflater/issues/54#issuecomment-803400481
    config.middleware.use Rack::Deflater,
      include: Rack::Mime::MIME_TYPES.values.grep(/text|json|javascript/).uniq,
      if: lambda { |env, status, headers, body| body.body.length > 512 }

    config.hosts.clear

    config.action_mailer.default_url_options = { host: ENV.fetch("HOST") }

    config.generators do |g|
      g.view_specs false
      g.routing_specs false
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.factory_girl false
    end
  end
end
