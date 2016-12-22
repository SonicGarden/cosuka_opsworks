# See: https://forums.aws.amazon.com/thread.jspa?messageID=429893&#429893
app = :rails

Chef::Log.info("[INFO] Running deploy/before_migrate.rb")
env = node[:deploy][app][:rails_env]
current_release = release_path
Chef::Log.info("[INFO] Execute before_migrate.rb. env:#{env} cwd:#{current_release}")

environments_text = ""
exclude_environment_keys = %w(RAILS_ENV RUBYOPT RACK_ENV HOME)
new_resource.environment.keys.each{|key| environments_text += "#{key}=#{new_resource.environment[key]}\n" unless exclude_environment_keys.include?(key) }

execute "generate dotenv file" do
  cwd current_release
  command "ruby -e 'File.write(\"./.env.#{env}\", \"#{environments_text}\");'"
end

execute "rake assets:precompile" do
  cwd current_release
  command "bundle exec rake assets:precompile"
  environment "RAILS_ENV" => env
end
