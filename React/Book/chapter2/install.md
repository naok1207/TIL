# 開発環境準備

React本体のパッケージをローカルにインストールする
```
$ npm install --save react
```

npmインストール時のオプション
|オプション|省略形|追加される場所|役割|例|
|--save|-S|dependencies|プロダクトと直接的に依存関係にあたるパッケージ|reactなどプロダクトを作るために必要なライブラリ|
|--save-dev|-D|devDeoendencies|開発作業に利用されるパッケージ|babelやjestなどビルド作業や品質向上のために利用するライブラリ|
|--global|-g|(package.jsonには追加されない)|プロジェクトを横断して利用できるように実行環境へインストールされる|create-react-appなどパッケージから提供されている独自コマンドを使いたい場合|


package.jsonに記述されているパッケージをまとめてインストールする
```
$ npm install
```

babel実行に必要なパッケージのインストール
```
$ npm install --save-dev babel-cli babel-preset-react
```

```
# .babelrc
{
  "presets": [
    "env",
    "react"
  ]
}
```

```
// package.json
{
  "scripts": {
      // ...
      "babel": "babel src/index.js -o compiled.js"
    }
}
```


React本体とReactDOMのインストール
```
$ npm instakk --save react react-dom
```

render内でも変数定義やif文などのjavascriptの基本構文は使えるが使うべきではない
=>
肥大化の原因になるから
美しく扱いやすいReactコンポーネントを目指す必要がある。


props: コンポーネントのインターフェース
コンポーネントを表示するために必要な値をPropsと呼ばれるもので受け取ることができる。

**Atomic Design**
デザインガイドライン
コンポーネント単位でUIを作成する
5つの要素からなる
- Atomic(原子) 
  - 最小の要素
  - 入力エリアやボタンなど
- Molecules(分子)
  - Atomicを集めて一つの要素としたもの
  - 入力エリアやボタンをあわせた入力フォームなど
- Organisms(有機物)
  - 複数のAtomic・Moleculesがを集めて一つの要素としたもの
  - ヘッダーやフッターなど
- Templates(テンプレート)
  - Organismsを集めて一つの要素としたもの
  - データが反映される前の状態
  - ワイヤーフレームのようなもの
- Pages(ページ)
  - Templateにデータを流し込んだもの
  - Templateのインスタンスのようなもの
  - 表示崩れなどをしてはいけない


**webpack**
依存関係にあるファイルは正しい順序でファイルを読み込まなければいけないが、webpackでバンドルすることで依存関係を解決することができる。
それぞれをまとめたファイルができる。
`html-webpack-plugin`などさまざまなプラグインが提供されている

**webpack-dev-server**
```
npm install --save-dev webpack-dev-server
```
webpackをビルドするツール
ローカルホスト上にサーバーが起動した状態で利用する

**HMR**
p.112
webpack-dev-serverが提供する強力な機能
Hot Module Repalacement
アプリケーション実行中に一部のモジュールのみを差し替え更新することができる。
一時的な状態を持っているケースでも、それを保ったままソースコードの変更点を反映できる
Bタブの状態で編集したいのに更新するとAタブに戻ってしまうといった時に便利

`npm install --save react-hot-loader`
```
const path = require('path');

module.exports = {
  entry: [
    'babel-polyfill',
    'react-hot-loader/path',
    './src/index.js'
  ],
  output: {
    path: path.resolve(__dirname, 'public'),
    filename: 'bundle.js',
    publicPath: '/'
  },
  module: {
    rules: [
      {
        test: /|.js$/,
        use: {
          loader: 'babel-loader',
          options: {
            preset: [
              ['env', { modules: false }],
              'react'
            ],
            plugins: ['react-hot-loader/babel']
          }
        }
      }
    ]
  },
  devServer: {
    contentBase: path.join(__dirname, 'public'),
    port: 9000
  }
}
```