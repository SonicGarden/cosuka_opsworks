class CosukaOpsworksGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  desc 'For opsworks deployment hook files'
  def opsworks_deploy
    template 'deploy/after_restart.rb'
    template 'config/backup.rb'
    template 'config/schedule.rb'
    template '.github/workflows/check-whenever-config.yml'
  end
end
