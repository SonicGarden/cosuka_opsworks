require 'cosuka_opsworks/healthcheck'
require 'cosuka_opsworks/maintenance'
require 'cosuka_opsworks/disk_space'

module CosukaOpsworks
  class Railtie < ::Rails::Railtie
    initializer :initialize_coska_opsworks do |app|
      unless ::Rails.env.in?(%w[development test])
        middleware = ::Rails.configuration.middleware
        middleware.insert 0, CosukaOpsworks::Healthcheck
        middleware.insert_before CosukaOpsworks::Healthcheck, CosukaOpsworks::Maintenance
      end
    end

    rake_tasks do
      load 'cosuka_opsworks/tasks.rb'
    end
  end
end
