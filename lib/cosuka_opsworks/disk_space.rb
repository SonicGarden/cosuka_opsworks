module CosukaOpsworks
  module DiskSpace
    module_function

    def host_name
      Socket.gethostname
    end

    def usage(mount_point: '/')
      output = `df | grep '#{mount_point}$'`
      output[/\d+%/].to_i
    end
  end
end
