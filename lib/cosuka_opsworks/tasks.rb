namespace :cosuka_opsworks do
  desc 'Watch disk space'
  task :watch_disk_space, [:mount_point, :threshold] => :environment do |_, args|
    args.with_defaults(mount_point: '/', threshold: 80)

    usage_percentage = CosukaOpsworks::DiskSpace.usage(mount_point: args[:mount_point])
    if usage_percentage >= args[:threshold].to_i
      raise "[#{CosukaOpsworks::DiskSpace.host_name}] Disk space now using #{usage_percentage}%"
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
end
