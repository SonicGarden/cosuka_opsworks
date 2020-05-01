require 'cosuka_opsworks/healthcheck'
require 'cosuka_opsworks/maintenance'
require 'cosuka_opsworks/disk_space'

module CosukaOpsworks
  class Engine < ::Rails::Engine
    isolate_namespace CosukaOpsworks

    initializer :initialize_coska_opsworks do |app|
      unless ::Rails.env.in?(%w[development test])
        middleware = ::Rails.configuration.middleware
        middleware.insert 0, CosukaOpsworks::Healthcheck
        middleware.insert_before CosukaOpsworks::Healthcheck, CosukaOpsworks::Maintenance
      end
    end
  end
end
