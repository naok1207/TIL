# メモのメモをするアプリ
学習者向けのアプリ
googleで調べ物している時に一々メモ開くのがめんどくさい
知らない単語が出てきたところでどこにメモをしようか迷う

## 機能
- ユーザ
  - システムを使う人
  - 自分に関する情報やら設定やら
- メモ
  - Qiitaの記事の小ボリューム版
  - markdown によるメモ
  - 状態を管理
    - 未編集
    - 一時保存
    - 完成
  - アクセスレベル設定
    - 未公開
    - 限定公開
    - 公開
  - ブックマーク
  - ユーザの削除時にメモを残すか決められる
- カテゴリ
  - 自身のメモを整理するためのもの
  - 大カテゴリ, 小カテゴリ, とすることができる。
- タグ
  - 全ユーザのメモの種類わけ
  - 検索とかで使う
  - 関連がなくなったタグを自動削除
- 検索
  - 全ユーザ検索
  - 特定ユーザ検索
  - 自己検索
- google 拡張機能
  - 外部からのメモの作成
    - ローカルに認証キーを設定して自身に送る
    - title だけ
  - カーソルにより選択してコンテキストで処理を実行する
    - title + body
  - ショートカットキーによりテキストエリアを表示して送る
- 成長記録
  - カレンダー
    - いつ調べたかを見える化する
  - マインドマップ
    - カテゴリから伸びていく図を作成する
- admin
  - 色々見られる様にする

## 機能 - 追加
- カラーテーマ
  - 全体の色
  - markdown設定
- line bot
  - google 拡張機能 の様にlineから追加できる様にする
- ランキング
  - 現在の流行をしる
    - 今週の新規タグランキング
    - 今週の人気メモ
    - など
- auth
  - github
  - google
- メモ
  - 関連するメモの表示
    - データ解析
  - markdown
    - ショートカットキーの設定
- ユーザ
  - フォロー機能
  - グループ機能
    - 特定のユーザ間でメモを共有できる様にする

## エンドポイント
[![Image from Gyazo](https://i.gyazo.com/f0e7ba31b7a15375a718323389bb2d8d.png)](https://gyazo.com/f0e7ba31b7a15375a718323389bb2d8d)

## エンティティ
- user
  - username
  - email
  - access_token
  - avatar
  - introduction

- memo
  - title
  - body
  - user_id
  - category_id
  - state
  - access_level

- category
  - name
  - user_name
  - parent_id

- tag
  - name

- memo_tag_relation
  - memo_id
  - tag_id


## 構成
- 言語
  - ruby
- フレームワーク
  - ruby on rails
- データベース
  - mysql
- サーバ
  - heroku
  - aws rds
  - aws s3
