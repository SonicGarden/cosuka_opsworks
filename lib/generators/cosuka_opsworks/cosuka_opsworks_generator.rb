class CosukaOpsworksGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  desc 'For opsworks deployment hook files'
  def opsworks_deploy
    template 'deploy/after_restart.rb'
    template 'config/backup.rb'
    template 'config/schedule.rb'
  end
end
