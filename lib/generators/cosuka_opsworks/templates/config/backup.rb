##
# Backup v5.x Configuration
#
# Documentation: http://meskyanichi.github.io/backup
# Issue Tracker: https://github.com/meskyanichi/backup/issues
require 'socket'
require 'dotenv'

rails_env = 'production'
app_name = 'sample-app-name' # FIXME
rails_root    = '/srv/www/rails/current'
log_directory = "#{rails_root}/log"

host_name = Socket.gethostname
data_file_name_sym = (host_name + '_data').to_sym
log_file_name_sym = (host_name + '_log').to_sym

Dotenv.load("#{rails_root}/.env")
data = YAML.load_file("#{rails_root}/config/database.yml")
secrets = YAML.safe_load(ERB.new(File.read("#{rails_root}/config/secrets.yml")).result, aliases: true)
mandrill = secrets[rails_env]['mandrill']
aws_s3 = secrets[rails_env]['s3']

Storage::S3.defaults do |s3|
  s3.access_key_id      = ENV.fetch('AWS_ACCESS_KEY_ID')
  s3.secret_access_key  = ENV.fetch('AWS_SECRET_KEY_ID')
end

Notifier::Mail.defaults do |mail|
  mail.from                 = mandrill['user_name']
  mail.to                   = mandrill['user_name']
  mail.address              = mandrill['address']
  mail.port                 = mandrill['port']
  mail.domain               = mandrill['address']
  mail.user_name            = mandrill['user_name']
  mail.password             = mandrill['password']
  mail.authentication       = 'plain'
  mail.encryption           = :starttls
end

Compressor::Gzip.defaults do |compression|
  compression.level = 6
end

Encryptor::OpenSSL.defaults do |encryption|
  encryption.password = ENV.fetch('ENCRYPTION_KEY')
  encryption.base64   = true
  encryption.salt     = true
end

Backup::Model.new(data_file_name_sym, 'App Data Backup') do
  database PostgreSQL do |database|
    database.name               = data[rails_env]['database']
    database.username           = data[rails_env]['username']
    database.password           = data[rails_env]['password']
    database.host               = data[rails_env]['host']
    database.additional_options = ['-xc', '-E=utf8']
  end

  compress_with Gzip
  encrypt_with OpenSSL

  store_with S3 do |s3|
    s3.bucket             = aws_s3['backup']['data_bucket']
    s3.region             = aws_s3['backup']['region']
    s3.path               = "/#{app_name}"
  end

  notify_by Mail do |mail|
    mail.on_success = false
    mail.on_warning = true
    mail.on_failure = true
  end
end

Backup::Model.new(log_file_name_sym, 'App Log Backup') do
  archive :logs do |archive|
    archive.add "#{log_directory}/#{rails_env}.log"
    archive.add "#{log_directory}/#{rails_env}.log.1"
  end

  compress_with Gzip
  # encrypt_with OpenSSL

  store_with S3 do |s3|
    s3.bucket             = aws_s3['backup']['log_bucket']
    s3.region             = aws_s3['backup']['region']
    s3.path               = "/#{app_name}"
  end

  notify_by Mail do |mail|
    mail.on_success = false
    mail.on_warning = true
    mail.on_failure = true
  end
end
