Chef::Log.info('[INFO] Start deploy/after_restart.rb')
app = :rails

Chef::Log.info("[INFO] Running deploy/before_migrate.rb")
env = node[:deploy][app][:global][:environment]
current_release = release_path
Chef::Log.info("[INFO] Execute before_migrate.rb. env:#{env} cwd:#{current_release}")

# if env == 'production'
#   execute "rake copy_tuner:deploy" do
#     user deploy_user
#     cwd current_release
#     command "/usr/local/bin/bundle exec rake copy_tuner:deploy"
#     environment "RAILS_ENV" => env
#   end
# end
