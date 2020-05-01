class CosukaOpsworksGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  desc 'For opsworks deployment hook files'
  def opsworks_deploy
    template 'deploy/after_restart.rb'
    template 'config/backup.rb'
    template 'config/schedule.rb'

    initializer 'cosuka_opsworks.rb' do
      <<~EOF
        # CosukaOpsworks.from_email = 'cosuka_opsworks@example.org'
        # CosukaOpsworks.diff_emails = %w[cron_diff_alert@example.org]
      EOF
    end
  end
end
