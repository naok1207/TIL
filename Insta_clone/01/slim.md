# slimとは

**slimとは**
Ruby製のテンプレートエンジン
HTMLを短く書くことができる

**導入**
```
gem 'slim-rails'
```

**erb => slim 変換**
```
gem 'html2slim'
```
下記のコマンドを実行してerbファイルを削除
```
$ bundle exec erb2slim app/views/layouts/ --delete
```