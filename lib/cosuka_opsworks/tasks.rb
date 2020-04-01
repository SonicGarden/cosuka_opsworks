namespace :cosuka_opsworks do
  desc 'Watch disk space'
  task :watch_disk_space, [:mount_point, :max_percentage] => :environment do |_, args|
    args.with_defaults(mount_point: '/')
    args.with_defaults(max_percentage: 80)

    usage_percentage = CosukaOpsworks::DiskSpace.usage(mount_point: args[:mount_point])
    if usage_percentage >= args[:max_percentage].to_i
      raise "[#{CosukaOpsworks::DiskSpace.host_name}] Disk space now using #{usage_percentage}%"
    end
  end
end
