namespace :cosuka_opsworks do
  desc 'Watch disk space'
  task :watch_disk_space, [:mount_point, :threshold] => :environment do |_, args|
    args.with_defaults(mount_point: '/', threshold: 80)

    usage_percentage = CosukaOpsworks::DiskSpace.usage(mount_point: args[:mount_point])
    if usage_percentage >= args[:threshold].to_i
      raise "[#{Socket.gethostname}] Disk space now using #{usage_percentage}%"
    end
  end

  desc 'Watch nginx connections'
  task :watch_nginx_connections, [:threshold] => :environment do |_, args|
    args.with_defaults(threshold: 80)

    require 'cosuka_opsworks/nginx_status'
    status = CosukaOpsworks::NginxStatus.new
    usage_percentage = status.usage
    if usage_percentage >= args[:threshold].to_i
      raise "[#{Socket.gethostname}] Nginx connections now #{usage_percentage}% (#{status.active_connections}/#{status.worker_connections})"
    end
  end

  desc 'Output cron by config/schedule.rb'
  task :output_cron, [:rails_env, :type] => :environment do |_, args|
    require 'socket'
    require 'whenever'

    args.with_defaults(rails_env: 'production', type: 'master')
    master_host = args[:type] == 'master' ? Socket.gethostname : 'dummy.host'

    begin
      original_env = ENV.to_hash
      ENV.update('RAILS_ENV' => args[:rails_env], 'MASTER_HOST' => master_host)
      puts Whenever::JobList.new(file: 'config/schedule.rb').generate_cron_output
    ensure
      ENV.replace(original_env)
    end
  end

  desc 'Update crontab by config/schedule.rb'
  task update_cron: :environment do
    require 'whenever'

    output_command = 'crontab -l | grep -v "# Begin Whenever" | grep -v "# End Whenever" | sed -e \'s/releases\/[0-9]\+/releases\/RELEASE_DIR/g\''
    old_tmp = Tempfile.open
    old_crontab = `#{output_command} > #{old_tmp.path}`

    Kernel.system('/usr/local/bin/bundle exec whenever -i rails', exception: true)

    new_tmp = Tempfile.open
    new_crontab = `#{output_command} > #{new_tmp.path}`

    diff = `diff -u #{old_tmp.path} #{new_tmp.path}`
    if diff.present?
      CosukaOpsworks::DiffMailer.cron_diff(diff).deliver_now
    end
  end
end
