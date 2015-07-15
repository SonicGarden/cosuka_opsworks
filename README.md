# CosukaOpsworks

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/cosuka_opsworks`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cosuka_opsworks', git: 'https://github.com/SonicGarden/cosuka_opsworks.git'
```

And then execute:

    $ bundle

## Usage

Add in config/application.rb

    require 'cosuka_opsworks/healthcheck'
    config.middleware.use CosukaOpsworks::Healthcheck

    require 'cosuka_opsworks/maintenance'
    config.middleware.use CosukaOpsworks::Maintenance
