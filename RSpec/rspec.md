# 最初に

このアプリケーションが持っている昨日

- ユーザーはプロジェクトを追加できる。追加したプロヘクトはそのユーザーにだけ見える。
- ユーザーはタスクとメモと添付ファイルをプロジェクトに追加できる
- ユーザーはタスクを完了済みにできる。
- ユーザーアカウントはGravatarによって提供されるアバターを持っている
- 開発者はパブリックAPIを使って、外部のクライアントアプリケーションを開発できる。

**RSpec 準備**

Gemfileにrspecのgemを追加
```
# Gemfile
group :development, :test do
    gem 'rspec-rails', '~> 3.16.0'
end
```

rspecフォルダを作成
```
$ bin/rails g rspec:install
```

テストドキュメント出力を変更
```
# .rspec
--require spec_helper

--format documentation
```

rspec binstub を使ってテストスイートの起動時間を速くする
```
# bin ディレクトリにspec実行ファイルを作成する
$ bundle exec spring binstub rspec
```

ゲネレータ設定
rails g コマンドを実行時RSpecファイルを自動生成
config/application.rbに追記
```
config.generators do |g|
      g.test_framework :rspec,
      fixtures: false,
      view_specs: false,
      helper_specs: false,
      routing_specs: false
end
```

モデル スペック 作成
```
$ bin/rails g rspec:model user
```

**it について**
Userなど頭の文字に続くように動詞から書き始めることで自然な文章になる


