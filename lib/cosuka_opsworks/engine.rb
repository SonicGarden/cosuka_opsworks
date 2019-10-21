require 'cosuka_opsworks/healthcheck'
require 'cosuka_opsworks/maintenance'

module CosukaOpsworks
  class Engine < ::Rails::Engine
    initializer :initialize_coska_opsworks do |app|
      unless ::Rails.env.in?(%w[development test])
        middleware = ::Rails.configuration.middleware
        middleware.insert 0, CosukaOpsworks::Healthcheck
        middleware.insert_before CosukaOpsworks::Healthcheck, CosukaOpsworks::Maintenance
      end
    end
  end
end
