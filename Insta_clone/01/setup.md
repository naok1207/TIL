# 環境構築

**rails new オプション**

-d database データベースを変更
-T テストを作成しない
-G gitignoreを作成しない
-f 上書きでnew
-s 存在するファイルはスキップ
-q ログを表示しない
-J javascriptを読み込まない
--skip-keeps keepを読み込まない
--skip-turbolinks turbolinksを無効化
-h ヘルプを表示

--skip-coffee coffeeを無効化

**アプリケーション作成コマンド**
Ruby: 2.6.4
Rails: 5.2.3
DB: MySQL
turbolink: false
coffee-script: false
```
$ rbenv local 2.6.4
$ rails _5.2.3_ new Insta-clone -d mysql --skip-turbolinks --skip-coffee
$ cd Insta-clone
$ git init
$ git commit -m "initail commit"
$ git flow init
$ git push --all
$ git flow feature start 01_login_logout
```

- ジェネレータ設定
- タイムゾーン設定
- ビューテンプレートのslim化
- rubocopの導入
- redis-railsの導入
- rails-i18nの導入
- annotateの導入
- デバッグgemの導入
- BMDの導入
