# redisとは

**redisとは**
キャッシュシステムとして有名であり、NoSQLの一つ
セッションなどの有効期限のあるデータを扱う場合やランキングデータなど重たいSQLを走らせないといけない処理を扱う場合

**インストール**
```
$ brew install redis
```

**サーバーの起動**
```
$ redis-server
```

**redisに接続**
```
$ redies-cli
127.0.0.1:6379>
```

**railsのSessionStoreとしてRedisを使う**
gemの追加
'redis-rails'と'redis-session-store'があるがどちらも同じようなもの
```
gem 'redis-rails'
```

セッションの設定は config/initializers/session_store.rb に記述する.
```
Rails.application.config.session_store :redis_store, {
    servers: [
        {
            host: ENV['REDIS_HOST'] || 'localhost',
            port: ENV['REDIS_PORT'] || 6379,
            db: 0,
            namespace: 'session'
        }
    ],
    expire_after: 90.minutes
}
```