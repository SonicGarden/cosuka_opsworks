namespace :cosuka_opsworks do
  desc 'Watch disk space'
  task :watch_disk_space, [:mount_point, :threshold] => :environment do |_, args|
    args.with_defaults(mount_point: '/')
    args.with_defaults(threshold: 80)

    usage_percentage = CosukaOpsworks::DiskSpace.usage(mount_point: args[:mount_point])
    if usage_percentage >= args[:threshold].to_i
      raise "[#{CosukaOpsworks::DiskSpace.host_name}] Disk space now using #{usage_percentage}%"
    end
  end

  desc 'Output cron'
  task :output_cron, [:rails_env, :master_host] => :environment do |_, args|
    require 'socket'
    require 'whenever'

    args.with_defaults(rails_env: 'production')
    args.with_defaults(master_host: Socket.gethostname)

    begin
      original_env = ENV.to_hash
      ENV.update('RAILS_ENV' => args[:rails_env], 'MASTER_HOST' => args[:master_host])
      puts Whenever::JobList.new(file: 'config/schedule.rb').generate_cron_output
    ensure
      ENV.replace(original_env)
    end
  end
end
