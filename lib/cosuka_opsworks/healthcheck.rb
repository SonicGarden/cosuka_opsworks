require 'rack'
require 'rack/request'

module CosukaOpsworks
  class Healthcheck
    def initialize(app, options = {})
      @app = app
    end

    def call(env)
      if healthcheck_request?(env)
        healthcheck(env)
      else
        @app.call(env)
      end
    end

    private
      def healthcheck_request?(env)
        /^\/healthchecks$/ =~ ::Rack::Request.new(env).path_info
      end

      def healthcheck(env)
        headers = { 'Content-Type' => 'text/html' }

        if database_accessible?
          [200, headers, ['OK']]
        else
          [503, headers, ['ERROR']]
        end
      end

      def database_accessible?
        !!ActiveRecord::Base.connection.tables.sort.first
      rescue => e
        Rails.logger.error "[CosukaOpsworks] Failed to connect database. #{e.inspect}"
        false
      end
  end
end
