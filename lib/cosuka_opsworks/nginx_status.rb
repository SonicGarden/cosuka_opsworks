module CosukaOpsworks
  class NginxStatus
    def usage
      ((active_connections.to_f / worker_connections).round(2) * 100).to_i
    end

    def active_connections
      @active_connections ||= command("curl http://127.0.0.1/nginx_status | grep 'Active connections'")[/\d+/].to_i
    end

    def worker_connections
      @worker_connections ||= command('grep worker_connections /etc/nginx/nginx.conf')[/\d+/].to_i
    end

    private

    def command(cmd)
      output = `#{cmd}`
      if Process.last_status.exitstatus != 0
        raise "command error: #{cmd}"
      end
      output
    end
  end
end
