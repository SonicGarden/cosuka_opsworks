# Learn more: http://github.com/javan/whenever
require 'socket'

host_name = Socket.gethostname
rails_env = ENV['RAILS_ENV'] || ENV['RACK_ENV']

env :CRON_TZ, 'Japan'
env :PATH, '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
env :MASTER_HOST, ENV.fetch('MASTER_HOST')

set :environment, rails_env
set :job_template, nil
set :path, File.realpath('../', __dir__)
set :output, "#{path}/log/batch.log"
set :backup_file, "#{path}/config/backup.rb"
set :estimate_time, 180

# Use 24-hour clock to avoid errors
# OK: 03:00, 18:00
# NG: 3:00 am, 6:00 pm
set :chronic_options, hours24: true

job_type :rake, 'cd :path && RAILS_ENV=:environment bundle exec rake :task :output'
job_type :backup, 'cd :path && RAILS_ENV=:environment backup perform :task :output'
job_type :jobmon, 'cd :path && RAILS_ENV=:environment bundle exec jobmon --estimate-time :estimate_time :task :output'

if rails_env == 'production'
  if host_name == ENV['MASTER_HOST']
    every 1.day, at: '02:00' do
      backup "-t #{host_name}_data --config_file '#{backup_file}'"
    end
  end

  every 1.day, at: '07:10' do
    backup "-t #{host_name}_log --config_file '#{backup_file}'"
  end
end

every 30.minutes do
  rake 'cosuka_opsworks:watch_disk_space'
  # NOTE: jobmonを利用する場合はこちら推奨
  # jobmon 'cosuka_opsworks:watch_disk_space'
end

if host_name == ENV.fetch('MASTER_HOST')
  # マスターホストでのみ実行するジョブはここに記述
end
