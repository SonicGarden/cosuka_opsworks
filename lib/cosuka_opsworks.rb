require 'cosuka_opsworks/version'
require 'cosuka_opsworks/engine'

module CosukaOpsworks
  class << self
    attr_accessor :from_email
    attr_accessor :diff_emails
  end
end
