# database.ymlとは

**database.ymlとは**
Railsにおけるデータベース設定ファイル
Railsアプリケーションを作成時自動で生成され、デフォルトではSQLiteを使用する前提で作成される

**databaseの選択**
railsアプリケーション作成時`-d`オプションを付けることにより設定可能
```
$ rails new . -d DATABASE
```
使用可能なデータベース
- mysql
- oracle
- postgresql
- sqlite3
- frontbase
- ibm_db
- sqlserver
- jdbcmysql
- jdbcsqlite3
- jdbcpostgresql
- jdbc

作成されたファイルでの語句
```
adapter:   使用するデータベース種類
encoding:  文字コード
reconnect: 再接続するかどうか
database:  データベース名
pool:      コネクションプーリングで使用するコネクションの上限
username:  ユーザー名
password:  パスワード
host:      MySQLが動作しているホスト名
```

**参考**
[【Rails】【DB】database.yml](https://qiita.com/ryouya3948/items/ba3012ba88d9ea8fd43d)