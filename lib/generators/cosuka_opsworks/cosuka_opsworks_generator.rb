class CosukaOpsworksGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  desc 'For opsworks deployment hook files'
  def opsworks_deploy
    template 'deploy/after_restart.rb'
    template 'config/backup.rb'
    template 'config/schedule.rb'

    # NOTE: `template '.github/workflows/check-whenever-config.yml'`だと機能しなかったので
    template 'github/workflows/check-whenever-config.yml', '.github/workflows/check-whenever-config.yml'
  end
end
