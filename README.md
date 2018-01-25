# CosukaOpsworks

RailsアプリをOpsWroksで動かす際に以下の機能を提供

* ELBによるHealthcheckのための受け口を提供（DB疎通確認あり）
* ${RAILS_ROOT}/tmp/stop.txt 配置でメンテナンス画面を表示

## 注意

chef11の環境で利用する場合は、 __chef11__ ブランチを利用してください。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cosuka_opsworks', git: 'https://github.com/SonicGarden/cosuka_opsworks.git'
```

And then execute:

    $ bundle

And generate deployment hook files

    $ bin/rails g cosuka_opsworks

## Settings

Replace app-name in config/backup.rb:10

    app_name = 'sample-app-name'


データバックアップ時の暗号化処理のための環境変数を本番サーバにのみに設定してください。
値については下記でランダムな文字列を生成してください。

```
bundle exec rake secret
```

    ENCRYPTION_KEY='生成された値'
