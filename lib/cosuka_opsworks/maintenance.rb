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
        [503, headers, File.open([Rails.root, 'public', '503.html'].join('/'))]
      else
        @app.call(env)
      end
    end

    private

    def maintenance_mode?
      File.exist?([Rails.root, 'tmp', 'stop.txt'].join('/'))
    end
  end
end
