# postgresql エラー

以下のエラーが発生した
```
$ psql postgres
# => psql: error: could not connect to server: could not connect to server: No such file or directory
        Is the server running locally and accepting
        connections on Unix domain socket "/tmp/.s.PGSQL.5432"?
```

まずは下記を試したが失敗
```
$ brew services restart postgresql
```
```
$ brew uninstall postgresql
$ brew install postgresql
```
```
$ brew update && brew upgrade # 時間かかる
```

下記を実行により成功

https://qiita.com/ms2sato/items/a0f7d32a3ecda76a7be3
こちらの記事を参考にし、postgresのフォルダを確認したところ,
/usr/local/var/postgres/ の中身が postgres.old となっていた為削除し

```
$ rm -r /usr/local/var/postgres/postgres.old

# その後こちらのコマンドでエラーが発生した為
$ psql postgres

# Homebrew により postgresql を再インストール
$ brew uninstall postgresql
$ brew install postgresql

# この時点でエラーが解消された
$ psql postgres
postgres=# 
```

正しいやり方かはわからないが直った