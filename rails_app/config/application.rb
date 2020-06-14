# frozen_string_literal: true

require_relative "boot"

# only require Rails libraries that we actually use, this shaves off some memory
# ActionMailbox and ActionText are not currently used by the app
# see https://github.com/rails/rails/blob/v6.0.2.1/railties/lib/rails/all.rb
%w[
  active_record/railtie
  active_storage/engine
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  action_cable/engine
  rails/test_unit/railtie
  sprockets/railtie
].each do |lib|
  require lib
end

require "view_component/engine"

Bundler.require(*Rails.groups)
Dotenv::Railtie.load

module Sheepdog
  class Application < Rails::Application
      # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults(6.0)

    config.active_record.observers = %i[]

    config.generators do |g|
      g.assets false
      g.stylesheets false
      g.helpers false
    end


  # Log to STDOUT because Docker expects all processes to log here. You could
    # then redirect logs to a third party service on your own such as systemd,
    # or a third party host such as Loggly, etc..
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.log_tags  = %i[uuid]
    config.logger    = ActiveSupport::TaggedLogging.new(logger)

    config.action_mailer.default_url_options = {
      host: ENV["ACTION_MAILER_HOST"]
    }
    config.action_mailer.default_options = {
      from: ENV["ACTION_MAILER_DEFAULT_FROM"]
    }

    # Set Redis as the back-end for the cache.
    config.cache_store = :redis_cache_store, { url: "#{ENV['REDIS_BASE_URL']}cache" }

    # Load/require lib/core_ext
    config.autoload_paths += Dir[Rails.root.join("lib", "core_ext", "*.rb")].each { |l| require l }

    # Set Sidekiq as the back-end for Active Job.
    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix = "#{ENV['ACTIVE_JOB_QUEUE_PREFIX']}}"

    # Action Cable setting to de-couple it from the main Rails process.
    config.action_cable.url = ENV["ACTION_CABLE_FRONTEND_URL"]

    # Action Cable setting to allow connections from these domains.
    # origins = ENV['ACTION_CABLE_ALLOWED_REQUEST_ORIGINS'].split(',')
    # origins.map! { |url| /#{url}/ }
    # config.action_cable.allowed_request_origins = origins
    config.action_cable.allowed_request_origins = %r http:\/\/localhost*
  end
end
