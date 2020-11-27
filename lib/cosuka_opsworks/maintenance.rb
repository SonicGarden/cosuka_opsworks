require 'rack'
require 'rack/request'

module CosukaOpsworks
  class Maintenance
    def initialize(app, options = {})
      @app = app
    end

    def call(env)
      if maintenance_mode?
        headers = { 'Content-Type' => 'text/html' }
        [503, headers, File.open(maintenance_file_path)]
      else
        @app.call(env)
      end
    end

    private

    def maintenance_mode?
      File.exist?(stop_file_path)
    end

    def maintenance_file_path
      name = IO.read(stop_file_path).remove(/[^\w-]/).presence || '503'
      Rails.public_path.join("#{name}.html")
    end

    def stop_file_path
      Rails.root.join('tmp/stop.txt')
    end
  end
end
