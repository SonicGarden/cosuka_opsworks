require 'cosuka_opsworks/version'

if defined?(::Rails::Railtie)
  require 'cosuka_opsworks/railtie'
else
  puts 'Please CosukaOpsworks setup by manual.'
end

module CosukaOpsworks
end
