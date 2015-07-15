# CosukaOpsworks

RailsアプリをOpsWroksで動かす際に以下の機能を提供

* ELBによるHealthcheckのための受け口を提供（DB疎通確認あり）
* ${RAILS_ROOT}/tmp/stop.txt 配置でメンテナンス画面を表示

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
