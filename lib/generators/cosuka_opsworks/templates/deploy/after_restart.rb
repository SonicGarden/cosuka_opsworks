Chef::Log.info('[INFO] Start deploy/after_restart.rb')
require 'socket'
app = :rails
role = 'rails-app'
hostname = Socket.gethostname
deploy_user = 'deploy'
time = Time.now.strftime('%Y%m%d_%H%M_%Z')
current_release = release_path
Chef::Log.info("[INFO] Execute after_restart.rb in #{hostname}. USER:#{deploy_user}, CWD:#{current_release}")

Chef::Log.info('[INFO] Analize node info')
env = node[:deploy][app][:global][:environment]
Chef::Log.info("[INFO] Detected ENV:#{env}")

# ref) http://docs.aws.amazon.com/ja_jp/opsworks/latest/userguide/data-bag-json-instance.html
master_server_hostname = search('aws_opsworks_instance', 'status:online OR status:running_setup OR status:requested OR status:booting').map { |instance| instance['hostname'] }.min
Chef::Log.info("[INFO] Detected MASTER_SERVER_HOSTNAME:#{master_server_hostname}")

# デフォルトではデプロイ時の自動公開処理は無効化してあります。必要ならコメントを外してください。
# タイムベースのインスタンスの起動時、障害からの自動復旧時などに、意図せず CopyTuner の公開処理が走ることがあるので危険です。
# if env == 'production' && hostname == master_server_hostname
#   execute 'rake copy_tuner:deploy' do
#     cwd current_release
#     user deploy_user
#     command '/usr/local/bin/bundle exec rake copy_tuner:deploy'
#     environment 'RAILS_ENV' => env
#   end
# end

Chef::Log.info('[INFO] update crontab')
execute 'update crontab' do
  user deploy_user
  cwd current_release
  command '/usr/local/bin/bundle exec whenever -i rails'
  environment 'RAILS_ENV' => env, 'MASTER_HOST' => master_server_hostname
end
