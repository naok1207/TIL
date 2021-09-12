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

### elastic search
[参考](https://qiita.com/windows222/items/acb89451d6744e4361a3)

### search kiq

### rdb と nosql
rdbに比べnosqlは検索が爆速

### markdown
redcarpet
commonmarker
[参考](https://blog.piyo.tech/posts/2018-05-31-markdown-gem/)

pygment
シンタックスハイライトライブラリ

[参考](https://nansystem.com/what-is-markdown-it-and-frequently-used-plugins/)
markdown-it

## markdown 実装 簡易
### Use
- redcarpet
- github-markdown-css
- generate-github-markdown-css
- highlight.js

#### redcarpet
markdown parser
```
gem 'redcarpet'
```

ヘルパーを作成`markdown_helper.rb`
```
module MarkdownHelper
  def markdown(content)
    return '' unless content.present?
    @options ||= {
        filter_html: true,
        autolink: true,
        space_after_headers: true,
        fenced_code_blocks: true,
        underline: true,
        highlight: true,
        footnotes: true,
        tables: true,
        hard_wrap: true,
        xhtml: true,
        link_attributes: {rel: 'nofollow', target: "_blank"},
        strikethrough: true
    }
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, @options)
    @markdown.render(content).html_safe
  end
end
```

オプション
- `filter_html`
- `autolink`
- `space_after_headers`
- `fences_code_blocks`
- `underline`
- `hightlight`
- `footnotes`
- `tables`
- `hard_wrap`
- `xhtml`
- `link_attributes`
- `strikethrough`

markdownを設置する場所に以下を追記
```
.markdown-body
  = markdown @post.content
```

#### css
- github-markdown-css
  - githubのcssを作成するためのライブラリ
- generate-github-markdown-css
  - github-markdown-css を実行するためのライブラリ

```
yarn add --dev github-markdown-css
yarn global add generate-github-markdown-css
generate-github-markdown-css > app/javascript/stylesheets/markdown.scss
```

`application.scss`にてimport
```
@import './markdown';
```

`markdown.scss`の一部変更
```
# 前
.markdown-body :root {
# 後
:root {
```

#### highlight.js
- syntax highlight を適用させるためのライブラリ
```
yarn add highlight.js
```

`packs/markdown.js`を作成し以下を追記
```
import hljs from 'highlight.js';
import 'highlight.js/styles/github.css';
document.addEventListener('DOMContentLoaded', (event) => {
  document.querySelectorAll('pre code').forEach((block) => {
    hljs.highlightBlock(block);
  });
});
```

目的のファイル(.html.slim)で以下を追記
```
= javascript_pack_tag 'markdown'
```

`show.html.slim` でjavascriptで要素に処理を実行する際には以下の記述でいけるのですが、
```
document.addEventListener('DOMContentLoaded', (event) => {}
```

`update.js.slim` で ajaxにより部分変更を行った後に処理を実行することができません。
変更を行った部分に対してjavascriptを適用させる方法ってありますか？

現在 markdown の機能を作成していてajaxで更新したものに対してシンタックスハイライトを入れたいと思っています。

rails-ujsを利用したajax通信でシンタックスハイライトを反映させるためには
グローバルメソッドとして定義する必要がある(その他の方法があるかもしれません)
```
document.addEventListener('DOMContentLoaded', (event) => {
  reflectHighlight();
});

function reflectHighlight() {
  document.querySelectorAll('pre code').forEach((block) => {
    hljs.highlightBlock(block);
  });
}

window.reflectHighlight = reflectHighlight
```
`update.js.slim`
```
|
  reflectHighlight();
```


### ユーザプロフィール
- アバター追加
- 紹介文

#### アバター追加
- Uploader作成
- 画像リサイズ 400x400 (サイズは使うギリギリのサイズに設定予定のため変更する可能性も)
- default画像設定
- rmagick
- avatar:string
- 本番環境ではS3を利用して画像をアップロードする様にする
- carrierwave

**gem**
```rb
gem 'carrierwave'
gem 'rmagick', '4.1.2'
```

本番環境ではS3に保存する様にする

#### エンドポイント
githubのエンドポイントを確認したところ
profile関連は全て`users/:username`にまとめられていた

#### 概要
- mypageでの編集 と users#show からの編集の二つを用意
- avatarはmypageからのみで変更を行い
- introcuctionはusers#show 及び mypageの両方から編集できることとする
- エンドポイントはusers#showに全てまとめ表示変更処理はjquery及びcontrollerで行う

### ajax
rails-utlにより`remote: true`で起こったajaxのイベントを`on ajax:success`で受け取ることができる
```
$("#new-form").on('ajax:success', function(e) {
  data = e.detail[0];
  ...
})
```


### vscode slim 自動インデント
- 改行時必要なインデントにする
- = が含まれている場合
  - = の左右に空白があるかどうかを確認

### wantedlyの検索が綺麗

### タスクランナー

### さすインポート

### 確認画面ありのupload
画面推移
new -> confirm (ajax) -> create
image_cacheを用いる


### button submit 無効化
```
button type="button"
```
これだけ

### form オブジェクト
[参考](https://applis.io/posts/rails-design-pattern-form-objects)


### 検索機能実装ドキュメント
- 全検索
  - 公開されているメモ全体から探す方法
- 自身検索
  - 自分自身のカテゴリやメモ一覧内でそれ以下の階層に存在するメモやカテゴリを検索する
- 個人検索
  - 見ているユーザ内を検索

####  form オブジェクト + ransack で 複数検索機能を作る
##### ransack による複数検索
[参考](https://qiita.com/EastResident/items/54047e6e85dda0418dad)
最終コード
```rb
def search
  # キーワードを空白区切りで格納
  key_words = params[:q].split(/[\p{blank}\s]+/)
  # rasack の grupingsに用いるハッシュを作成
  grouping_hash = keyword.each_with_index.reduce({}){|hash, (word, index)| hash.merge(index.to_s => { title_or_content_cont: word })}
  # and繋ぎでsqlを発行し実行
  Category.ransack({ combinator: 'and', groupings: grouping_hash, s: 'name desc' }).result
end
```

実質こんな感じにパラメータを送ればいい
```rb
@q = Post.ransack({ combinator: 'and', groupings: {post: {title_cont: "post"}, aaa: {title_cont: "aaa"}}, s: 'title desc' })
@q = Post.ransack({ combinator: 'and', groupings: {post: {title_cont: "post"}, aaa: {title_cont: "aaa"}}})
Post.ransack({ combinator: 'or', groupings: {post: {title_cont: "post"}, aaa: {title_cont: "aaa"}}}).ransack({ combinator: 'or', groupings: {post: {title_cont: "post"}, aaa: {title_cont: "aaa"}}})

Post.ransack({ combinator: 'and', groupings: {post: {title_cont: "post"}, ss: {title_cont: "ss"}, post: {content_cont: "post"}, ss: {content_cont: "ss"}}})
```

[参考](https://qiita.com/naoa/items/eb0062a4847ac7acd8ac)
```
{
  combinator: 'and',
  groupings: {
    '0' => {'col1_or_col2_cont' => 'hogehoge'},
    '1' => {'col1_or_col2_cont' => 'hogehoge'}
  }
}
```
自分
```
{
  combinator: 'and',
  groupings: {
    '0' => {'title_or_content_cont' => 'post'},
    '1' => {'title_or_content_cont' => 'ss'}
  }
}
```


これだとtitleとcontentの中身にそれぞれpostとaaaが入っていた場合に検索に当てはまらないためオブジェクトを生成
```rb
class SearchPost
  attribute :text, :string


end
```

##### form object 様に分ける
```rb
def own_search
end

def other_search

end

def whole_search

end

private
def grouping_hash
  key_words = params[:q].split(/[\p{blank}\s]+/)
  keywords.reduce({}){|hash, word| hash.merge(word => { title: word })}
end
```

#### 素のsql
(title like keyword or content like keyword) and (title like keyword2 or content like keyword2)

(A or B) and (A or B)

```sql
SELECT `posts`.* FROM `posts` WHERE (`posts`.`title` LIKE '%post%' AND `posts`.`title` LIKE '%aaa%') /* loading for inspect */ ORDER BY `posts`.`title` DESC LIMIT 11

SELECT `posts`.* FROM `posts` WHERE (`posts`.`title` LIKE '%<keyword>' AND `posts`.`title` LIKE `%<keyword>%`)

SELECT `posts`.* FROM `posts` WHERE (`posts`.`title` LIKE '%post%' and `posts`.`title` Like '%aaa%')

SELECT `posts`.* FROM `posts` WHERE (`posts`.`title` LIKE '%post%' or `posts`.`content` LIKE '%post%') and (`posts`.`title` LIKE '%aaa%' or `posts`.`content` LIKE '%aaa%')

```

(A or B or C) and (A or B or C)
```sql
SELECT * FROM tables WHERE (tables.A or tables.B or tables.C) and (tables.A or tables.B or tables.C)
```
ransack
```rb
Post.ransack(
  combinator: 'and',
  groupings: {
    '0' => {'title_or_content_cont' => 'post'},
    '1' => {'title_or_content_cont' => 'ss'}
  }
).result
```
```rb
Post.ransack(combinator: 'and', groupings: groupings_hash)
```

完成
```rb
key_word = "ruby on rails docker nginx apatch"
# key_word = params[:q].split(/[\p{blank}\s]+/)
key_word = key_word.split(/[\p{blank}\s]+/)
grouping_hash = keyword.each_with_index.reduce({}){|hash, (word, index)| hash.merge(index.to_s => { title_or_content_cont: word })}
Post.ransack({combinator: 'and', groupings: grouping_hash}).result
```

メソッド化
```rb
def multiple_search(matcher, key_word)
  key_words = key_word.split(/[\p{blank}\s]+/)
  grouping_hash = key_words.each_with_index.reduce({}){|hash, (word, index)| hash.merge(index.to_s => { matcher => word })}
  Post.ransack({combinator: 'and', groupings: grouping_hash}).result
end
```
実行文
```rb
key_word = "ruby on rails docker nginx apatch"
key_word = "post aaa ss"
multiple_search(:title_or_content_cont, key_word)
```
sql
```sql
SELECT `posts`.* FROM `posts`
WHERE ((`posts`.`title` LIKE '%ruby%' OR `posts`.`content` LIKE '%ruby%')
AND (`posts`.`title` LIKE '%on%' OR `posts`.`content` LIKE '%on%')
AND (`posts`.`title` LIKE '%rails%' OR `posts`.`content` LIKE '%rails%')
AND (`posts`.`title` LIKE '%docker%' OR `posts`.`content` LIKE '%docker%')
AND (`posts`.`title` LIKE '%nginx%' OR `posts`.`content` LIKE '%nginx%')
AND (`posts`.`title` LIKE '%apatch%' OR `posts`.`content` LIKE '%apatch%'))
```

### ユーザ作成時のvalidate
ユーザ名が被らないようにチェック
emailのvalidate
passwordのvalidate


```
```

```sql
SELECT post.* FROM posts WHERE (A OR B) AND (C) OR D
```


### redisable
mastodon

### .env credential
credential - master key - 保守性
.env - 保守性が低い

### docker CI に設定

### aws ec2 rds

### 業務職歴経歴書
-

### 使ったサービスについて
- 決済機能ってどうやって作る？


### カテゴリー以下のメモ一覧の取得
カテゴリーに`/:parent/:parent/`の様に繋げて格納する
```
id: 1
under_category_ids: /

id:2
under_category_ids: /1/

id:3
under_category_ids: /2/3/
```
```rb
# default
category = Category.find(self.parent_id)
self.under_category_ids = category.under_category_ids + category.id + '/'
```

```rb
# categoryに関連する親カテゴリをすべ取得
category_ids = category.under_category_ids.split("/").reject(&:blank?).map!(&:to_i).push(category.id)
```

```rb
# 自身に関連するカテゴリを全て取得する
# category_ids = current_user.categories.where("category_relation_ids LIKE ?", "%/#{category.id}/%").pluck(:id)
category_ids = current_user.categories.where("under_category_ids LIKE ?", "%/#{category.id}/%").pluck(:id)
category_ids.push(category.id)
current_user.memos.where(category_id: category_ids)
```


### オーバーライドを使わないcreate
コールバックで代替する例
```rb
before_create do
  self.code = RandomString.generate(length: 8)
end
```

### 検索 ルーティング
```rb
resources :memos do
  resource :search, only: :show
end
resources :categories do
  resource :search, only: :show
end
resources :user do
  resource :search, only: :show
end
```
```
 category_search GET  /categories/:category_name/search(.:format) searches#show
     memo_search GET  /memos/:memo_id/search(.:format)            searches#show
user_memo_search GET  /:user_username/search(.:format)            searches#show
```


### chartjs
色々チャートが使える

### ダイレクトアップロード
サーバーを解さずにs3にアップロードすることで高速化を図る

### ActiveHash

### だいそんさん formObject
https://github.com/DaichiSaito/case_study_form_object_2/tree/develop

### 検索 履歴を残す

### 全てのgemの使った意味を言える様にする

### ActiveStrage

### コクーン
cocoon
[参考](https://k-koh.hatenablog.com/entry/2020/06/27/125710)

### サービスクラス
call
excec
run

### rubocop
[参考](https://qiita.com/ikechan515/items/3bb1f9614be0ef65268e)


### zip 出力
git archive HEAD --format=zip --output=exports.zip


### デザインいい
[参考](https://fun-technology.net/)
[参考](futo-moriya.herokuapp.com/Portfolio/)

ただの水をどう売るか

### capybara
### webdrivers
### draper
### decorator
### techessential
[気になる](https://tech-essentials.work/courses/11/tasks/27/outputs/550)
[気になる](https://recursionist.io/)

### nullを許容するのはよくない
別テーブルにdeleted_atを作成し、削除したユーザはチェックを入れておき退会済みかどうか判別する

### デットロック
[気になる](https://blog.ingage.jp/entry/2020/03/16/080000)
[気になる](https://qiita.com/NagaokaKenichi/items/73040df85b7bd4e9ecfc)

### search reload
urlにsearchの情報を含ませておきリロードした時に検索を走らせる

### 実践ガイド

### ルーティング
- namespace :searches
  - searches/contents#show
- resource :searches or resource :searches
  - contents#show

### 検索 リロード時に情報を保持する
[参考](https://qiita.com/nightyknite/items/b350dc95f7da089a516a)
javascriptのhistoryを利用して検索履歴を追加した後にurlを書き換える
parameterを設定しておきparameterがあった時のみ検索を行って表示を置き換える様にする


### 存在チェック
[参考](https://qiita.com/anoworl/items/8d5ff9c95c2097d6b53b)
```
defined? hoge #=> false
```


### docker webpack
webpack専用コンテナを作成してHMRを行う

### Figma
pngなどにfillsをかけられる

### 例外を起こしてデバッグ
raiseにより例外を起こしてデバッグ操作画面を開く
`raise ActiveRecord::rollback`?

fluent d

logがすぐ貯まる

### flutter

### svg path ベジェ曲線

### メモ編集時
- 変更箇所があり、離れる際には離脱して良いかの確認を行う

### メモ 状態管理
- メモに状態(status)を持たせる
  - incomplete
    - 未完成状態
  - complite
    - 完成状態
- ユーザが能動的に変更をしないと完成とならない
- enum
  - integer
    - boolean だと色々注意が必要なため
  - 0 incomplite  default
  - 1 complite
- 完成時にカレンダーに反映される様にする
- カレンダーへの反映は選択式にしてもいいかも
- update の隣にチェックボックスを設置する
  - チェックボックスをつけている状態で更新を行うと完成状態に
  - チェックボックスを外している状態で更新を行うと未完成状態に
- enum form select
  [参考](https://morizyun.github.io/ruby/rails-function-enum-select-tag.html)

### メモ公開レベル
-

### ブックマーク
- [共同開発](https://morizyun.github.io/)
- [js animation framework aos](https://github.com/michalsnik/aos)
- cloudflare

### typescript
[参考](https://book.yyts.org/)

### 閲覧数
[参考](https://qiita.com/ryouzi/items/727063547da2432beda9)
`gem 'impressionist'`

### next js を利用したSPAへの移行
next js + typescript の学習を兼ねたrailsアプリケーションのSPA化を行う


### google api localstrage
[参考](https://mae.chab.in/archives/2861)


### pluck hash column
pluckする際にカラム情報を保持してハッシュを作成する
- gem pluck_to_hash
```
Category.all.pluck_to_hash(:id, :name)
```
- mapを用いる
```
Category.all.pluck(:id, :name).map{ |id, name| {id: id, name: name} }
```
- zipを用いる
```
attr = %w(id name)
Category.all.pluck(*attr).map { |p| attrs.zip(p).to_h }
```

[参考](https://zaiste.net/posts/rails-pluck-to-hash/)


### minds 繰り返し
```rb
@categories.filter{|category| category[:parent_id] == nil}.each do |parent|
  while parent.any?
    puts "----------------"
    puts parent
    @categories.filter{|category| category[:parent_id] == parent[:id]}.each do |parent|
      puts parent
    end
  end
end
```

### helper moduleを用いた再帰呼び出し
```rb
module MindsHelper
  def generate_minds(parent_id = nil)
    html = ''
    @categories.filter{|category| category[:parent_id] == parent_id}.each do |parent|
      html += "<div class='category-group'>"
      html += "<div class='neo mind-card'>#{parent[:name]}</div><div class='children'>"
      html += generate_minds(parent[:id]) if @categories.any?{|category| category[:parent_id] == parent[:id]}
            html += "<div class='memo-group'>"
      @memos.filter{|memo| memo.category_id == parent[:id]}.each do |memo|
        html += "<div>"
        html
      end
      html += "</div>"
      html += "</div>"
      html += "</div>"
    end
    return html.html_safe
  end
end
```

### 後で見る
[ポートフォリオレビュー会](https://drive.google.com/file/d/111cjQTB_LqMgIrNA6drYW0IVu0tMWhC1/view)


### flexbox spacebeteween 最後 左寄せ
[参考](https://blog.webcreativepark.net/2016/08/15-125202.html)

#### 解決方法
擬似要素を作成してboxを埋める

```scss
.flex_box {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;

  &::before {
    order: 1;
  }
  &::before, &::after {
    content: '';
    display: block;
    width: 300px;
  }
}
```

### slack 例外通知
slack notifire


role bar


### 追加機能
- パンくずリスト
- アカウントアクティベーション

### 論理削除
- deleted_at により削除日時を保存することで削除されたことを担保する
- 論理削除の場合削除したユーザを参照するときが大変
- 他のカラムへ削除したユーザをまるまる移動させるのもあり

### OGP画像
urlを貼り付け時に画像が表示される様になる
meta-tags


### 500エラー
exceptionb_notification

### パフォーマンス分析ツール
NewRelic

### rubocop 警告
[参考](https://qiita.com/tbpgr/items/a9000c5c6fa92a46c206)

### direct upload

### rails markdown
[参考](https://hirozak.space/posts/rails-blog)


### meta-tags
- default_meta_tags
- set_meta_tags

#### set_meta_tags
- memo show set ogp
- else no index

[参考](https://qiita.com/tomomomo1217/items/912afba852dc524d748e)

### clouddinary 動的 OGP
- アカウント作成
- asset画像追加
- 環境変数追加
- url生成メソッド作成
- twitterの設定


### 修正事項
- meta title ja.yml title: '...' => index: '...' へ修正
- OGP画像修正
- 同じタグを複数持たない様に制限

### docker
[参考](https://mmtomitomimm.blogspot.com/2018/04/docker-mysqldb.html)
[参考](https://zenn.dev/junki555/articles/13da16e4f10c9dee2bb9)
#### mysql のみを docker-compose で起動
Dockerfile
```yml
version: '3.8'
services:
  db:
    image: mysql:8.0
    ports:
      - '3306:3306'
    volumes:
      - mysql:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ALLOW_EMPTY_PASSWORD: 'yes'
volumes:
  mysql:

```
command
```
docker-compose run db mysql -h db -P 3306 -u root
```

**ポイント**
ホスト名とポート番号を指定してmysqlを起動すること

#### mysql 設定
```
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
```

### nginx + unicorn
[参考](https://qiita.com/E6YOteYPzmFGfOD/items/509dbabeb20bf2487283)


### 本番環境エラー箇所
- settings
  - redis
  - cloudinary
- env
  - RAILS_ENV
- tmp/pids/unicorn.pid 作成
- https://qiita.com/keiya01/items/5ea1ef8c2f70b68fde6c
- webpacker packs manifest
  - packs 以下に作成したjsファイル名にあったmanifestが生成される


### nginx unicorn エラー
エラーメッセージ全体
```
nginx_1  | 172.31.0.25 - - [15/Aug/2021:00:05:09 +0000] "GET / HTTP/1.1" 502 1635 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36"
nginx_1  | 2021/08/15 00:05:09 [error] 8#8: *1 connect() to unix:/app/tmp/sockets/.unicorn.sock failed (111: Connection refused) while connecting to upstream, client: 172.31.0.25, server: localhost, request: "GET / HTTP/1.1", upstream: "http://unix:/app/tmp/sockets/.unicorn.sock:/", host: "www.memomo.tk"
nginx_1  | 172.31.0.25 - - [15/Aug/2021:00:05:10 +0000] "GET /favicon.ico HTTP/1.1" 200 0 "https://www.memomo.tk/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36"
```
エラーメッセージ一部抜粋
```
[error] 8#8: *1 connect() to unix:/app/tmp/sockets/.unicorn.sock failed (111: Connection refused)
```

ソケットがうまく繋がっていないみたい？
->
nginx 側ではなく rails 側の問題のようだ
```
$ docker-compose -f production.yml ps
         Name                       Command               State            Ports
-----------------------------------------------------------------------------------------
memo_for_memos_app_1     bundle exec unicorn -p 300 ...   Exit 1
memo_for_memos_nginx_1   /docker-entrypoint.sh /bin ...   Up       0.0.0.0:80->80/tcp
memo_for_memos_redis_1   docker-entrypoint.sh redis ...   Up       0.0.0.0:6379->6379/tcp
```

unicornのログを調査
```
# log/unicorn.log

bundler: failed to load command: unicorn (/usr/local/bundle/bin/unicorn)
/usr/local/bundle/gems/unicorn-5.7.0/lib/unicorn/http_server.rb:207:in `pid=': Already running on PID:1 (or pid=/app/tmp/pids/unicorn.pid is stale) (ArgumentError)
	from /usr/local/bundle/gems/unicorn-5.7.0/lib/unicorn/http_server.rb:139:in `start'
	from /usr/local/bundle/gems/unicorn-5.7.0/bin/unicorn:128:in `<top (required)>'
	from /usr/local/bundle/bin/unicorn:23:in `load'
	from /usr/local/bundle/bin/unicorn:23:in `<top (required)>'
	from /usr/local/lib/ruby/3.0.0/bundler/cli/exec.rb:63:in `load'
	from /usr/local/lib/ruby/3.0.0/bundler/cli/exec.rb:63:in `kernel_load'
	from /usr/local/lib/ruby/3.0.0/bundler/cli/exec.rb:28:in `run'
	from /usr/local/lib/ruby/3.0.0/bundler/cli.rb:497:in `exec'
	from /usr/local/lib/ruby/3.0.0/bundler/vendor/thor/lib/thor/command.rb:27:in `run'
	from /usr/local/lib/ruby/3.0.0/bundler/vendor/thor/lib/thor/invocation.rb:127:in `invoke_command'
	from /usr/local/lib/ruby/3.0.0/bundler/vendor/thor/lib/thor.rb:392:in `dispatch'
	from /usr/local/lib/ruby/3.0.0/bundler/cli.rb:30:in `dispatch'
	from /usr/local/lib/ruby/3.0.0/bundler/vendor/thor/lib/thor/base.rb:485:in `start'
	from /usr/local/lib/ruby/3.0.0/bundler/cli.rb:24:in `start'
	from /usr/local/lib/ruby/gems/3.0.0/gems/bundler-2.2.3/libexec/bundle:49:in `block in <top (required)>'
	from /usr/local/lib/ruby/3.0.0/bundler/friendly_errors.rb:130:in `with_friendly_errors'
	from /usr/local/lib/ruby/gems/3.0.0/gems/bundler-2.2.3/libexec/bundle:37:in `<top (required)>'
	from /usr/local/bin/bundle:23:in `load'
	from /usr/local/bin/bundle:23:in `<main>'
```

unicorn.pid と .unicorn.sock を削除して assets:precompile
