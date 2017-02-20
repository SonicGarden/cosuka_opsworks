app = :rails
role = "rails-app"

Chef::Log.info('[INFO] Start deploy/after_restart.rb')
env = node[:deploy][app][:rails_env]
hostname = node[:opsworks][:instance][:hostname]
master_server = node[:opsworks][:layers][role][:instances].keys.sort.first.to_s
current_release = release_path
deploy_user = 'deploy'
time = Time.now.strftime("%Y%m%d_%H%M_%Z")

Chef::Log.info("[INFO] Execute after_restart.rb in #{hostname}. ENV:#{env} CWD:#{current_release} USER:#{deploy_user}")

Chef::Log.info("[INFO] Detect master server. hostname:#{hostname} master_server:#{master_server}")

execute 'update crontab' do
  user deploy_user
  cwd current_release
  command 'bundle exec whenever -i rails'
  environment 'RAILS_ENV' => env, 'MASTER_HOST' => master_server
end

if env.to_s == 'production'
  execute 'git tag and push' do
    user deploy_user
    cwd current_release
    command "git tag #{time}-#{hostname} HEAD && git push --tag"
    environment 'RAILS_ENV' => env
  end
end
