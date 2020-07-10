# CosukaOpsworks

Rails アプリを OpsWroks で動かす際に以下の機能を提供

- ELB による Healthcheck のための受け口を提供（DB 疎通確認あり）
- \${RAILS_ROOT}/tmp/stop.txt 配置でメンテナンス画面を表示
- ディスク残容量の監視

## 注意

chef11 の環境で利用する場合は、 **chef11** ブランチを利用してください。

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

## Tasks

### `cosuka_opsworks:output_cron[rails_env,type]`

`config/schedule.rb` を crontab 形式に変換した結果を確認できます。

#### default args

- rails_env: `production`
- type: `master`

#### Usage

production & master host

```
cosuka_opsworks:output_cron
```

production & slave host

```
cosuka_opsworks:output_cron[production,slave]
```

staging & master host

```
cosuka_opsworks:output_cron[staging]
```

### `cosuka_opsworks:watch_disk_space[mount_point,threshold]`

ディスク使用量が`threshold`%以上であれば例外を発生させます。

#### default args

- mount_point: `/`
- threshold: `80`

#### Usage

マウントポイント`/`の使用量が`95`%以上

```
cosuka_opsworks:watch_disk_space[/,95]
```

### `cosuka_opsworks:watch_nginx_connections[threshold]`

Nginx コネクション数が`threshold`%以上であれば例外を発生させます。

#### default args

- threshold: `80`

#### Usage

Nginx コネクション数が`80`%以上

```
cosuka_opsworks:watch_nginx_connections
```

## Github workflows

`rails g cosuka_opsworks` で追加される Github workflows です。

### cosuka-opsworks-action
whenever の設定ファイルに変更があれば、crontabの差分をPRにコメントしてくれます。

see: https://github.com/SonicGarden/cosuka-opsworks-action
