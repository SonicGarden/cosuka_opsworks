require 'cosuka_opsworks/healthcheck'
require 'cosuka_opsworks/maintenance'

module CosukaOpsworks
  class Engine < ::Rails::Engine
    initializer :initialize_coska_opsworks do |app|
      if ::Rails.env.in?(%w[staging production])
        middleware = ::Rails.configuration.middleware
        healthcheck_after = ::Rails.configuration.force_ssl ? ActionDispatch::SSL : Rack::Sendfile
        middleware.insert_before healthcheck_after, CosukaOpsworks::Healthcheck
        middleware.use CosukaOpsworks::Maintenance
      end
    end
  end
end