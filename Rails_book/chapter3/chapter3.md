# タスク管理アプリケーションを作ろう

|ツール|バージョン|
|---|---|
|Ruby|2.5.1|
|Ruby on Rails|5.2.1|
|PostgreSQL|10.5|

**手順**
- 作成するアプリケーションの内容を考える
- アプリケーションの名前を考える
- アプリケーションの雛形を作成する
- データベースを作成する

- ビュー層を効率よく書くためにSlimを使えるようにする
- アプリケーションの見栄えをよくする為にBootstrapを導入する
- Railsのエラーメッセージなどを日本語で出せるようにする

**作成するアプリケーションの内容**
- 一覧表示機能 : 全てのタスクの概要（名称と登録日時）を確認できる一覧画面を表示する
- 詳細表示機能 : ある１つのタスクの全内容（ID、名称、詳しい説明、登録日時、更新日時）を確認できる詳細画面を表示する
- 新規登録機能 : 新しいタスクのデータをフォーム画面で入力し、データベースに登録する
- 編集機能 : 登録済みのタスクのデータをフォーム画面で修正し、データベースを更新する
- 削除機能 : 登録済みのタスクをデータベースから削除する

**作成するアプリケーションの名前**
taskleaf

**アプリケーションの雛形**
```
$ rails new アプリケーション名 [オプション]
$ rails _5.2.1_ new taskleaf -d postgresql
```
```
$ cd taskleaf
$ bin/rails db:create
$ bin/rails s
```

**Slimの設定**
```ruby:Gemfile
# Gemfile に追記
gem 'slim-rails'
gem 'html2slim'
```
下記を実行し、既存しているerb ファイルを削除
```
$ bundle exec erb2slim app/views/layouts/ --delete
```

**bootstrapの導入**
```ruby:Gemfile
# Gemfileに追記
gem 'bootstrap'
```
下記を実行
```
$ rm app/assets/stylesheets/application.css
$ echo '@import "bootstrap";' > app/assets/stylesheets/application.scss
```

**エラーメッセージを日本語で出せるようにする**
```
$ wget https://raw.githubusercontent.com/svenfuchs/rails-i18n/master/rails/locale/ja.yml -P config/locales/
$ echo 'Rails.application.config.i18n.default_locale = :ja' > config/initializers/locale.rb
```

**タスクモデルの属性を設計**
|属性の意味|属性名・カラム名|データ型|NULLを許可する|デフォルト値|
|---|---|---|---|---|
|名称|name|string|許可しない|なし|
|詳しい説明|description|text|許可する|なし|

**タスクモデル雛形作成**
```
# モデルの作成
$ bin/rails g model [モデル名] [属性名:データ型 属性名:データ型 ...] [オプション]

$ bin/rails g model Task name:string description:text
```

**マイグレーションでテーブル追加**
```
$ bin/rails db:migrate
```

**コントローラとビュー**
```
# コントローラーの作成
$ bin/rails g controller コントローラー名 [アクション名 アクション名 ...] [オプション]
$ bin/rails g controller tasks index show new edit
```
ルーティングを調整
```ruby:config/routes.rb
# config/routes
# 削除
get 'tasks/index'
get 'tasks/show'
get 'tasks/new'
get 'tasks/edit'

# 追記
root to: 'tasks#index'
resources 'tasks'
```

**複数行に渡るテキストを扱う時**
```ruby
    simple_format(h(@task.description), {}, sanitize: false, wrapper_tag: "div")
```
