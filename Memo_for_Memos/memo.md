# Memo for Memos 作成時 のインプットや処理作成手順

## ユーザ sorcery
- gem追加
- インストール
- テーブル作成
- フォーム作成

### gem追加
```rb
gem 'sorcery'
```

### インストール
```
bundle exec rails g sorcery:install remember-me
```
ユーザモデルとマイグレーションファイルが生成される

#### remember me の設定
config/initializers/sorcery.rb
```rb
Rails.application.config.sorcery.submodules = [:remember_me]
(中略)
config.user_config do |user|
  (中略)
  user.remember_me_for = 1209600 # Two weeks in seconds
  (中略)
end
```
migrationが自動で作成される
```rb
def change
    add_column :users, :remember_me_token, :string, default: nil
    add_column :users, :remember_me_token_expires_at, :datetime, default: nil

    add_index :users, :remember_me_token
  end
```
すでにデータが入っている場合は整合性を取る必要あり

#### ユーザ名によるログインの設定
config/initializers/sorcery.rb
```rb
user.username_attribute_names = [:username]
```
マイグレーションファイルで`:username, null: false`を設定
`uniq`も忘れずに

マイグレート

### コントローラ作成
```rb
def create
  if @user = login(params[:username], params[:password], params[:remember])
    redirect_to root_path
  else
    render :new
  end
end

def destroy
  remember_me!
  forget_me!
  logout
  redirect_to root_path
end
```
##### login(username, password. remember)
sorceryで定義されているメソッド
認証を行う
通常は`email`, `password` の二つでログイン可能
今回は`email`の代わりに`username`を利用しているのに加え`remember me`の情報を渡している

### フォーム作成


### その他
#### submodules
sorceryは機能ごとにサブモジュールが設定されており任意のサブモジュールをインストール可能
```
# sorceryのコア部分がインストールされる
rails g sorcery:install

# サブモジュールがインストールされる
rails g sorcery:insatll remember_me user_auth --only-submodules
```

存在するサブモジュール
- user_activation
- reset_password
- remember_me
- session_timeout
- brute_force_protection
- http_basic_auth
- activity_logging
- external

#### user_activation
```
rails g sorcery:install user_auth --only-submodules
```

#### reset_password

#### remember_me

#### session_timeout

#### brute_force_protection

#### http_basic_auth

#### actibity_logging

#### external

### username & email 両方からの認証
```
user.username_attribute_names = [:username, :email]
```
```
= f.text_field :login, nil, placeholder: 'username or email'
```
```
login(params[:login], params[:password], params[:remember_me])
```

### 参考
[github sorcery/sorcery](https://github.com/Sorcery/sorcery)
[[Ruby on Rails]sorceryによる認証 – (2)ユーザ名による認証とRemember-Me](https://dev.classmethod.jp/articles/ruby-on-rails_sorcery_auth_no2/)
[【Ruby on Rails】sorceryを使用したログインで、ユーザーネーム・emailのどちらでもログインできるようにする](https://hyperneetprogrammer.hatenablog.com/entry/login-with-sorcery-by-username-or-email)




## session_store エラー
ruby3.0に移行した時に発生したエラー
```
/configuration.rb:304:in `session_store': wrong number of arguments (given 2, expected 0..1) (ArgumentError)
```

修正前
```
Rails.application.config.session_store :redis_store, {
  servers: [
      {
          host: Settings.redis_host || 'localhost' ,
          port: Settings.redis_port || 6378,
          db: 0,
          namespace: 'session'
      }
  ],
  expire_after: 90.minutes
}

```
修正後
```
Rails.application.config.session_store :redis_store,
  servers: [
      {
          host: Settings.redis_host || 'localhost' ,
          port: Settings.redis_port || 6378,
          db: 0,
          namespace: 'session'
      }
  ],
  expire_after: 90.minutes

```
再度エラー
```
Error connecting to Redis on localhost:6378 (Errno::ECONNREFUSED)
```
修正
```
Rails.application.config.session_store :redis_store, url: Settings.redis.url, namespace: 'session', expire_after: 1.weeks
```
考えられる原因
- `http`を指定してしまうこと`redis`が正解
- ruby3での仕様変更による引数の渡し方などの変化

## email 一意性確保
- `format: {width: /VALID_EMAIL_REGEX/ }`
  - 正規表現の最初 `^`ではセキュリティの関係で弾かれるため`\A`を使用
- `uniqueness: { case_sensitive: false }`
  - 大文字小文字区別しないユニーク制約
- `before_save { self.email = email.downcase }`
  - 保存時に小文字化

## NGワード 禁止ワード
`/login|logout|signup/`正規表現を作る

## validate format 複数
`validates_format_of`を使う
```rb
validates_format_of :username, with: VALID_USERNAME_REGEX
validates_format_of :username, without: VALID_USERNAME_NGWORD
```
[validates_format_ofを使ってformat指定を複数適応させる](https://qiita.com/ngron/items/53fdf1fe4a0a2d5e51e2)

## クエリ キャッシュ
[Railsでクエリ結果をキャッシュしてDB負荷を軽減する](https://qiita.com/yamashun/items/bf9a3d29de749cf18f2e)


## uniq user ごと
[uniqueness: scope を使ったユニーク制約方法の解説](https://qiita.com/j-sunaga/items/d7f0e944baad6e56206c)

## hoverの仕方がかっこいい
https://photoshopvip.net/124402

## デザインかっこいい + svg素材 + デザイン参考
https://icons.theforgesmith.com/

## primary_key ランダム文字列
[【Rails】 id（並び順整数）をuuid（乱数）に変更](https://qiita.com/params_bird/items/9e162fdcd9bdc2e42ccd)
```
class CreateMemos < ActiveRecord::Migration[6.1]
  def change
    # ランダム文字列でidを生成
    create_table :memos, id: false do |t|
      t.string :id, limit: 20, null: false, primary_key: true
      t.string :title, null: false
      t.text :body
      t.references :category, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
```
```
class Memo < ApplicationRecord
  before_create :generate_hex_id
  belongs_to :category, optional: true
  belongs_to :user, optional: true

  def generate_hex_id
    self.id = loop do
      hex_id = SecureRandom.hex(10)
      break hex_id unless self.class.exists?(id: hex_id)
    end
  end
end

```


## bootstrap 5 調査
### bootstrap 自体
#### 導入
```
yarn add bootstrap
yarn add @popperjs/core
```
Popper v2 の対応によりbootstrap5からは`popper.js`から`@popperjs/core`に変更

`app/javascript/js/bootstrap_js_files.js`を作成し、使用するファイルのみをインポート
```js
// inside app/frontend/js/bootstrap_js_files.js

// import 'bootstrap/js/src/alert'
// import 'bootstrap/js/src/button'
// import 'bootstrap/js/src/carousel'
import 'bootstrap/js/src/collapse'
import 'bootstrap/js/src/dropdown'
// import 'bootstrap/js/src/modal'
// import 'bootstrap/js/src/popover'
import 'bootstrap/js/src/scrollspy'
// import 'bootstrap/js/src/tab'
// import 'bootstrap/js/src/toast'
// import 'bootstrap/js/src/tooltip'
```

`app/javascript/pack/application.js`でインポート
```
import '../js/bootstrap_js_files.js'
```

`app/javascript/stylesheets.scss`でインポート
```
@import "custom"
@import "~bootstrap/scss/bootstrap";
```

### purgeCss により未使用のCSSスタイルを削除
通常.scssファイルを.min.scssファイルにコンパイルして作成するが、その際importした未使用のCSSも含めて作成するためかなり巨大なコードが生成される

#### PurgeCss
CSSファイルとHTML/Javascriptファイルに対して実行し、使用されるCSSコンテンツを解析および分析し、未使用のCSSコンテンツを削除する

#### 導入
```
npm i --save-dev purgecss
```
CLIにより操作可能

#### 使用方法
```
purgecss --css <cssファイル>-content <cssを解析するコンテンツファイル>-out <出力ディレクトリ>
```

#### 参考
[PurgeCSSを使用してブートストラップから未使用のCSSスタイルを削除します](https://medium.com/dwarves-foundation/remove-unused-css-styles-from-bootstrap-using-purgecss-88395a2c5772)

### post-css-loader
Node.js製のモジュールでCSSをコンパイルできるツール
CSS拡張しをソースとして新しいCSSを生成してくれる
コンパイルめちゃ早い

### webpack への移行
[参考](https://kyoncy.site/rails-webpack/)
[参考](https://kyoncy.site/webpack-react-ts-and-so-on/)

#### Sprockects から抜け出す
アセットパイプラインによるファイル配信を行わない
`app/assets/`ディレクトリを削除
`config/application.rb`
```
config.assets.enabled = false
```

#### webacker 削除
`gem webpacker`を削除
webpackerに関連するファイル・設定を削除
```
yarn remove @rails/webpacker
```
削除ファイル
- bin/webpack
- bin/webpack-dev-server
- config/webpack/development.js
- config/webpack/environment.js
- config/webpack/production.js
- config/webpack/test.js
- config/webpacker.yml
削除設定
`config/environment/development.rb` と `production.rb`から
`config.webpacker.check_yarn_inegrity`を削除

#### ディレクトリ構成
以下を作成
- frontend
  - javascripts
    - applicatioin.js
  - stylesheets
    - application.scss
  - images

#### webpack導入
webpack関連
```
yarn add --dev webpack weboack-cli
```
babel関連 (vue使わないならいらないかも?)
```
yarn add --dev @babel/core @babel/polyfill @babel/preset-env babel-loader babel-plugin-macros
```
loader各種
```
yarn add --dev css-loader file-loader mini-css-extract-plugin pug pug-plain-loader sass-loader webpack-manifest-plugin
```
package.jsonに追加
```
"scripts": {
  "build:dev": "webpack --progress --mode=development",
  "build:pro": "webpack --progress --mode=production"
},
```

**webpackの設定**
`webpack.config.js`を作成
```js
cconst path = require('path')
const glob = require('glob')
const webpack = require('webpack')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const { WebpackManifestPlugin } = require('webpack-manifest-plugin')

let entries = {}
glob.sync('./frontend/entries/*.js').map((file) => {
  let name = file.split('/')[3].split('.')[0]
  entries[name] = file
})

module.exports = (env, argv) => {
  const IS_DEV = argv.mode === 'development'

  return {
    entry: entries,
    // devtool: IS_DEV ? 'source-map' : 'none',
    output: {
      filename: 'javascripts/[name]-[hash].js',
      path: path.resolve(__dirname, 'public/assets')
    },
    plugins: [
      new MiniCssExtractPlugin({
        filename: 'stylesheets/[name]-[hash].css'
      }),
      new webpack.HotModuleReplacementPlugin(),
      new WebpackManifestPlugin({
        // fileName: 'manifest.json',
        // publicPath: "/assets/",
        writeToFileEmit: true
      }),
      new webpack.ProvidePlugin({
        $: "jquery",
        jQuery: 'jquery',
        jquery: 'jquery',
        "window.jQuery": 'jquery',
      }),
    ],
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          loader: 'babel-loader',
          options: {
            presets: [
              [
                '@babel/preset-env',
                {
                  targets: {
                    ie: 11
                  },
                  useBuiltIns: 'usage'
                }
              ]
            ]
          }
        },
        {
          test: /\.pug/,
          loader: 'pug-plain-loader'
        },
        // {
        //   test: /\.(c|sc)ss$/,
        //   use: [
        //     // MiniCssExtractPlugin.loader,
        //     // {
        //     //   loader: MiniCssExtractPlugin.loader,
        //     //   options: {
        //     //     publicPath: path.resolve(__dirname, 'public/assets/stylesheets')
        //     //   }
        //     // },
        //     // {
        //     //   loader: 'postcss-loader',
        //     //   options: {
        //     //     plugins: function() {
        //     //       return [
        //     //         require('precss'),
        //     //         require('autoprefixer')
        //     //       ];
        //     //     }
        //     //   }
        //     // },
        //     "css-loader",
        //     "sass-loader"
        //   ]
        // },
        {
          test: /\.(scss)$/,
          use: [
            {
              // CSSをページに挿入
              loader: 'style-loader',
            },
            {
              // CSSをCommonJSモジュールに変換
              loader: 'css-loader',
            },
            {
              // ポストCSSアクションを実行
              loader: 'postcss-loader',
              options: {
                // postcss 8.xには `postcssOptions`が必要;
                // postcss 7.xを使用する場合、キーをスキップ
                postcssOptions: {
                  // post cssプラグインは、postcss.config.jsにエクスポート可能
                  plugins: function () {
                    return [
                      require('autoprefixer')
                    ];
                  }
                }
              }
            },
            {
              // SassをCSSにコンパイル
              loader: 'sass-loader'
            }]
        },
        {
          test: /\.(jpg|png|gif)$/,
          loader: 'file-loader',
          options: {
            name: '[name]-[hash].[ext]',
            outputPath: 'images',
            publicPath: function(path) {
              return 'images/' + path
            }
          }
        }
      ]
    },
    optimization: {
      splitChunks: {
        cacheGroups: {
          vendor: {
            test: /.(c|sa)ss/,
            name: 'style',
            chunks: 'all',
            enforce: true
          }
        }
      }
    },
    devServer: {
      host: 'localhost',
      port: 3035,
      publicPath: 'http://localhost:3035/public/assets/',
      contentBase: path.resolve(__dirname, 'public/assets'),
      hot: true,
      disableHostCheck: true,
      historyApiFallback: true
    }
  }
}

```
色々モジュール追加してこれでやっとできた

**ヘルパータグの実装**
```rb
require "open-uri"

module WebpackBundleHelper
  class BundleNotFound < StandardError; end

  def javascript_bundle_tag(entry, **options)
    path = asset_bundle_path("#{entry}.js")

    options = {
      src: path,
      defer: true,
    }.merge(options)

    # async と defer を両方指定した場合、ふつうは async が優先されるが、
    # defer しか対応してない古いブラウザの挙動を考えるのが面倒なので、両方指定は防いでおく
    options.delete(:defer) if options[:async]

    javascript_include_tag "", **options
  end

  def stylesheet_bundle_tag(entry, **options)
    path = asset_bundle_path("#{entry}.css")

    options = {
      href: path,
    }.merge(options)

    stylesheet_link_tag "", **options
  end

  private

  def asset_server
    port = Rails.env === "development" ? "3035" : "3000"
    "http://#{request.host}:#{port}"
  end

  def pro_manifest
    File.read("public/assets/manifest.json")
  end

  def dev_manifest
    OpenURI.open_uri("#{asset_server}/public/assets/manifest.json").read
  end

  def test_manifest
    File.read("public/assets-test/manifest.json")
  end

  def manifest
    return @manifest ||= JSON.parse(pro_manifest) if Rails.env.production?
    return @manifest ||= JSON.parse(dev_manifest) if Rails.env.development?
    return @manifest ||= JSON.parse(test_manifest)
  end

  def valid_entry?(entry)
    return true if manifest.key?(entry)
    raise BundleNotFound, "Could not find bundle with name #{entry}"
  end

  def asset_bundle_path(entry, **options)
    valid_entry?(entry)
    asset_path("#{asset_server}/public/assets/" + manifest.fetch(entry), **options)
  end
end
```

`application.html.erb`のjs,cssを変更
```
// この2行を削除
= stylesheet_link_tag 'application', media: 'all'
= javascript_include_tag 'application'

// この2行を追加
= javascript_bundle_tag "application"
= stylesheet_bundle_tag "application", media: 'all'
```

#### webpack-dev-serverの導入
```
yarn add --dev webpack-dev-server
```
`webpack.config.js`に追記
```js
plugins: [
  ...
],
devServer: {
  host: 'localhost',
  port: 3035,
  publicPath: 'http://localhost:3035/public/assets/',
  contentBase: path.resolve(__dirname, 'public/assets'),
  hot: true,
  disableHostCheck: true,
  historyApiFallback: true
}
```

監視実行
```
yarn run webpack-dev-server --mode development
```

#### foreman
複数のプロセスを一度に立ち上げるgem
```rb
gem "foreman"
```
`Procfile`をルートディレクトリに作成し、追記
```
rails: bundle exec rails server
webpack-dev-server: yarn run webpack-dev-server --color --mode development
```

サーバ立ち上げコマンド
```
bundle exec foreman start -p 3000
```

#### 画像表示のためプロキシー設定
`lib/tasks/assets_path_proxy.rb`
```
require "rack/proxy"

class AssetsPathProxy < Rack::Proxy
  def perform_request(env)
    if env["PATH_INFO"].include?("/images/")
      if Rails.env != "production"
        dev_server = env["HTTP_HOST"].gsub(":3000", ":3035")
        env["HTTP_HOST"] = dev_server
        env["HTTP_X_FORWARDED_HOST"] = dev_server
        env["HTTP_X_FORWARDED_SERVER"] = dev_server
      end
      env["PATH_INFO"] = "/public/assets/images/" + env["PATH_INFO"].split("/").last
      super
    else
      @app.call(env)
    end
  end
end
```
`config/environment/development.rb & production.rb`のそれぞれに追記
```rb
require_relative '../../lib/tasks/assets_path_proxy'

Rails.application.configure do
  ...

  config.middleware.use AssetsPathProxy, ssl_verify_none: true
end
```

## ?
### webpackerを利用する理由
### redisを利用する理由
### bootstrapを利用する理由
### post-css-loaderについて
### sass-loaderについて
### Autoprefixerとは
### webpackerとwebpack
[参考](https://qiita.com/jesus_isao/items/1f519b2c6d53f336cadd)


### mindmap用 2点間に曲線を引く
[svgによるベジェ曲線](http://yamatyuu.net/computer/html/svg/bezier2.html)
[html要素の位置を取得する](https://maku77.github.io/js/dom/elem-pos.html)


### カレンダー作成
.rb
```rb
@tody = Data.today
from_date = Date.new(@today.year, @today.month, @today.beginning_of_month.day).geginning_of_week(:sunday)
to_day = Date.new(@today.year, @today.month, @todat.end_of_month.day).end_of_week(:sunday)
@calendar_data = from_date.uptp(to_date)
```
.slim
```
table
  tr
    - t('date.abbr_day_names').each do |day_name|
      td= day_name
  - @calendar_data.each do |date|
    - if date.wday == 0
      tr
    td= date.day
    - if date.wday == 6
      /tr
p= @today.strftime("< %m / %Y >")
```
i18n
```yml
ja:
  date:
    abbr_day_names:
      - Sun
      - Mon
      - Tue
      - Wed
      - Thu
      - Fri
      - Sat
```

## ルーティング
routes
```
get '/:year(/:month(:day))', to: 'memos#calender', constraints: { year: 'YYYY', month: 'MM', day: 'DD'}
```
controller
```rb
def calender
  @date
end
```


### tags
[参考](https://qiita.com/E6YOteYPzmFGfOD/items/bfffe8c3b31555acd51d)


### 月初め 終わり sql
```
-- 当月月初
SELECT DATE_FORMAT(CURDATE(), '%Y-%m-01');

-- 当月月末
SELECT LAST_DAY(CURDATE());
-- 前月月初
SELECT DATE_FORMAT(ADDDATE(CURDATE(), INTERVAL -1 MONTH), '%Y-%m-01');

-- 前月月末
SELECT LAST_DAY(ADDDATE(CURDATE(), INTERVAL -1 MONTH));
-- 次月月初
SELECT DATE_FORMAT(ADDDATE(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');

-- 次月月末
SELECT LAST_DAY(ADDDATE(CURDATE(), INTERVAL 1 MONTH));
```

### ページング
pages

### github pages
githubによる静的サイトのホスティングサービス
