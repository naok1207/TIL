# gem configについて

定数を管理する

## 導入
#### 1.gemの追加
`Gemfile`に追記
```ruby
gem 'config'
```

#### 2.configの初期設定を行う
初期設定のための関連ファイルをインストール
```
$ bundle exec rais g config:install
```

#### 3.定数の設定
`config/settings.yml`に定数を定義
```yml
service:
  name: 'vdeep'
  url: 'http://vdeep.net'

authentiaction_password: "foobarbaz"
```

結果
```ruby
$ rails c

> Settings.service.name
=> "vdeep"

> Settings.service[:name]
=> "vdeep"

> Settings[:service][:name]
=> "vdeep"

> Settings.authentication_password
=> "foobarbaz"
```

#### 例
`config/settings.local.yml`
```yml
web:
  host: 'example.com'#サイトのドメイン名
  protocol: 'https'#httpの場合はhttp

mail:
  bcc: 'admin@example.com' ##受信できるメールアドレス

smtp:
  address: 'smtp.example.com'#SMTPサーバーのホスト名
  port: 587#SMTPサーバーのポート番号
  domain: 'example.com'#メールアドレスのドメイン名
  user_name: 'admin@example.com'#メールアドレス
  password: 'a123456'#パスワード
```

呼び出し
```ruby
Settings.web[:host]

Settings.smtp[:address]
Settings.smtp[:port]
Settings.smtp[:domain]
Settings.smtp[:user_name]
Settings.smtp[:password]
```


## 参考
[【Rails】定数は、config gemで管理しましょう](https://qiita.com/beanbeenzou/items/87fb89f73e1b9e6490e1)
[【Rails】「config」の使い方](https://qiita.com/jungissei/items/133a18dc1095d0be557f)