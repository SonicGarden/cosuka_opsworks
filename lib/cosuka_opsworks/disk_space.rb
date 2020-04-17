module CosukaOpsworks
  module DiskSpace
    module_function

    def usage(mount_point: '/')
      output = `df | grep '#{mount_point}$'`
      output[/\d+%/].to_i
    end
  end
end
