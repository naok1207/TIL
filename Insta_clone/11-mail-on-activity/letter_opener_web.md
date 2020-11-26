# letter_opener_web について

開発環境で送信したメールをブラウザで確認するためのgem

## 導入
#### 1.Gemfile追記
```ruby
# Gemfile

group :development do
  gem 'letter_opener_web'
end
```

#### 2.`config/routes.rb`に追記
```ruby
Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
```

#### 3.`config/environments/development.rb`
```ruby
Rails.applicatoin.configure do
  config.action_mailer.perform_caching = false

  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  config.action_mailer.delivery_method = :letter_opener_web
end
```

#### 4.Mailer作成
コマンド実行
```ruby
$ rails g mailer UserMailer
```

`app/mailers/user_mailer.rb`
```ruby
class UserMailer < ActionMailer::Base
  default from: "hgoe@gmail.com"

  def send_message_to_user(user)
    @user = user
    mail to: @user.email,
      subject: "メールの件名が入ります"
  end
```

#### 5.メール本文の作成
`app/views/user_mailer/send_message_to_user.text.erb`を作成
`メソッド名.text.erb`という名前になる
```ruby
<%= @user.name %> さま

いつもお世話になっております。
株式会社●●です。
この度は、キャンペーンにご応募いただきまして、ありがとうございました。
当選発表は、商品の発送をもってかえさせていただきます。

株式会社●●
```

#### 6.メール送信処理
```ruby
class EntryController < ApplicationController
  def create
    @entry = Entry.new(entry_params)
    if @entryt.save
      # ここでメールを送信する
      UserMailer.send_message_to_user(@entry.user).deliver_now
      redirect_to root_url
    else
      render :new
    end
  end
end
```

#### 7.メールを確認する
`config/routes.rb`に追記した、メール確認画面を開く
画面を開くと送信処理があったメールを一覧できる（実際に送信されているわけではない）

## 参考
[Railsで、Action Mailerとletter_opener_webを初めて使いました](http://c5meru.hatenablog.jp/entry/2018/07/29/200011)