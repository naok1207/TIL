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


**Factory_bot**
gemの追加
```
group :development, :test do
    gem 'factory_bot_rails', "~> 4.10.0"
```

generators設定変更
```
# 以下を削除
fixtures: false
```

アプリケーションにファクトリを追加する
```
bin/rails g factory_bot:model user
```

userファクトリ作成
```
factory :user, aliases: [:owner] do # projectの関連付けが:ownerとなっているため
    first_name "Aaron"
    last_name "Sumner"
    # ユニークなメールアドレスを作成
    sequence(:email) { |n| "test#{n}@example.com" }
    password "dottle-nouveau-pavilion-tights-furze"
end
```

noteの作成
```
FactoryBot.define do
  factory :note do
    message "My important note."
    association :project
    association :user
  end
end
```

projectの作成
```
```

create_listメソッド, コールバック
```
# 関連のモデルが必要
trait :with_notes do
    after(:create) { |project| create_list(:note, 5, project: project) }
end
```

**コントローラースペック**
生成
```
$ bin/rails g rspec:controller home
```

deviseのテストヘルパーを使用する
```
# spec/rails_helper.rbに追記
config.include Devise::Test::ControllerHelpers, type: :controller
```

has_secure_passwordメソッドなどを使って認証機能を自分で作っている場合は、次のようにして自分でヘルパーメソッドを定義する
```
def sign_in(user)
    cookies[:auth_token] = user.auth_token
end
```

FactoryBotのファクトリからテスト用の属性値をハッシュとして作成
```
user_params = FactoryBot.attribute_for(:user)
```

**フィーチャースペック(feature spec)**
統合テスト
モデルやコントローラが他のモデルやコントローラと上手く一緒に動作することを確認する

導入
```
# Gemfile
group :test do
    gem 'capybara'
end

# spec/rails_helper.rb
require 'spec_helper'
require 'rspec/rails'
require 'capybara'

$ rails g rspec:feature projects
```

featureはscenario内に記述する
```
scenario "user create new project" do
    ...
    expect {
        ...
        expect(page).to have_content "..."
        ...
    }.to chage(user.projects, :count),by(1)
end
```

save_and_open_page を記述することでその時点でのhtmlを取得し、ファイルを保存する
このファイルは後に削除する必要がある

jsの動作を確認する場合は以下のように記述する
```
scenario "..." js: true do
end
```

**リクエストスペックでテストする**
Capybaraのようなブラウザの操作をシュミレートしないテスト
コントローラーのレスポンスをテストする際に使ったHTTP動詞に対応するメソッドを使う

```
$ rail g rspec:request project
```

著者はコントラースペックよりも統合スペックを強くお勧めしている。
だが、両方書けるようになっておくのが良い