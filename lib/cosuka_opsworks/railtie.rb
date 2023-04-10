require 'cosuka_opsworks/healthcheck'
require 'cosuka_opsworks/maintenance'
require 'cosuka_opsworks/disk_space'

module CosukaOpsworks
  class Railtie < ::Rails::Railtie
    initializer :initialize_coska_opsworks do |_app|
      unless ::Rails.env.in?(%w[development test])
        middleware = ::Rails.configuration.middleware
        middleware.insert 0, CosukaOpsworks::Healthcheck
        middleware.insert_before CosukaOpsworks::Healthcheck, CosukaOpsworks::Maintenance
      end
    end

    Rails::Engine.prepend(Module.new do
      def load_tasks
        super

        # NOTE: should add after sg_tiny_backup's tasks
        load 'cosuka_opsworks/tasks.rb'
      end
    end)
  end
end
