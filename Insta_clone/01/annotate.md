# annotateとは

**annotateとは**
各モデルのスキーマ情報をファイルの先頭もしくは末尾にコメントして書き出してくれるGem
config/routes.rbにルーティング情報を書き出してくれる機能もある。

**gemの追加**
```
gem 'annotate'
```

**設定ファイルを作成**
`lib/tasks/auto_annotate_models.rake`が作成される
```
$ bundle exec rails g annotate:install
```

**参考**
[【Rails】annotateの使い方](https://qiita.com/kou_pg_0131/items/ae6b5f41c18b2872d527)