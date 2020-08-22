変更を確認する
```
$ git diff
$ git diff --staged
```

変更履歴の確認
```
$ git log

# 一行で表示する
$ git log --online

# ファイルの変更差分を表示する
$ git log -p index.html

表示するコミット数を制限する
$ git log -n <コミット数>
```

ファイルの削除を記録する
```
# ファイルごと削除
$ git rm <ファイル名>
$ git rm -r <ディレクトリ名>

# ファイルを残したいとき (リポジトリから削除)
$ git rm --cached <ファイル名>
```

ファイルの移動を記録する
```
$ git mv <旧ファイル> <新ファイル>

# 以下のコマンドと同じ
$ mv <旧ファイル> <新ファイル>
$ git rm <旧ファイル>
$ git add <新ファイル>
``` 

リモートリポジトリ新規追加
```
$ git remote add origin https://github.com/user/repo.git
```

リモートリポジトリへ送信
```
$ git push <リモート名> <ブランチ名>
$ git push origin master
```

エイリアス
```
$ git config --global alias.ci commit
$ git config --global alias.st status
$ git config --global alias.br branch
$ git config --global alias.co checkout
```

バージョン管理しないファイルを除く方法
```
# .gitignore に追記
$ 
```

ファイルへの変更を取り消す
```
$ git checkout -- <ファイル名>
$ git checkout -- <ディレクトリ名>

# 全変更を取り消す
$ git checkout  -- .
```

ステージに追加した変更を取り消す
```
$ git reset HEAD <ファイル名>
$ git reset HEAD <ディレクトリ名>

# 全変更を取り消す
$ git reset HEAD .
```

直前のコミットを修正
```
$ git commit --amend
```

リモートを表示する
```
$ git remote

# 対応するURLを表示
$ git remote -v
```

リモートリポジトリを追加
```
$ git remote add <リモート名> <リモートURL>
$ git remote add tutorial https://github.com/user/repo.git
```

リモートから情報を取得する（フェッチ）
```
$ git fetch <リモート名>
$ git fetch origin

# 取得したブランチの確認
$ git branch -a

# 取得した情報を反映させる
$ git merge origin/master
```

リモートから情報を取得し反映させる（プル）
```
$ git pull <リモート名> <ブランチ名>
$ git pull origin master

# コマンドは省略可能
$ git pull

# 下記のコマンドと同じこと
$ git fetch origin master
$ git merge origin/master
```

リモートの詳細情報を表示する
```
$ git remote show <リモート名>
$ git remote show origin
```

リモート名の変更
```
$ git remote rename <旧リモート名> <新リモート名>
$ git remote rename tutorial new_tutorial
```

リモートを削除
```
$ git remote rm <リモート名>
$ git remote rm new_tutorial
```

ブランチの作成
```
$ git branch <ブランチ名>
$ git branch feature
```

ブランチ一覧を表示する
```
$ git branch

# 全てのブランチを表示する
$ git branch -a
```

ブランチを切り替える
```
$ git checkout <既存ブランチ名>
$ git checkout feature

# ブランチを新規作成して切り替える
$ git checkout -b <新規ブランチ名>
```

変更履歴をマージする
```
$ git merge <ブランチ名>
$ git merge <リモート名/ブランチ名>
$ git merge origin/master
```

ブランチ名の変更
```
$ git branch -m <ブランチ名>
$ git branch -m new_branch
```

ブランチを削除する
```
$ git branch -d <ブランチ名>
$ git branch -d feature

# 強制削除
$ git branch -D <ブランチ名>
```

リベースで履歴を整えた形で変更を統合する
```
$ git rebase <ブランチ名>

$ git checkout feature
$ git master

$ git checkout master
$ git merge feature
```

マージフォアワードをしないように設定する
```
$ git config --global merge.ff false
```

プルのマージ型 マージコミットが残る
```
$ git pull <リモート名> <ブランチ名>
$ git pull origin master
```

プルのリベース型 マージコミットが残らない
```
$ git pull --rebase <リモート名> <ブランチ名>
$ git pull --rebase origin master
```

プルをリベース型に設定する
```
$ git config --global pull.rebase true

# masterブランチでgit pullする時だけ
$ git config branch.master.rebase true
```

複数のコミットをやり直す
```
$ git rebase -i <コミットID>
$ git rebase -i HEAD~3

pick gh21f6d ヘッダー修正
pick 1930543 ファイル追加
pick 84gha0d README修正
```

HEAD~
1度目の親を指定する。
HEADを基点にして数値分の親コミットまで指定する。

タグ一覧表示
```
$ git tag
```

タグを作成する（注釈付き）
```
$ git tag -a [タグ名] -m "[メッセージ]"
$ git tag -a 20170520_01 -m "version 20170520_01"
```

タグのデータを表示する
```
$ git show [タグ名]
$ git show 20170520_01
```

タグをリモートに送信
```
$ git push [リモート][タグ名]
$ git push origin 20170520_01

# タグを一斉に送信する
$ git push origin --tags
```

作業の一時避難
```
$ git stash
$ git stash save
```

避難した作業を確認する
```
$ git stash list
```

避難した作業を復元する
```
# 最新の作業を復元する
$ git stash apply
# ステージの状況も復元する
$ git stash apply --index

# 特定の作業を復元する
$ git stash apply --index
$ git stash applu stash@{1}
```

避難した作業を削除する
```
# 最新の作業を削除する
$ git stash drop

# 特定の作業を削除する
$ git stash drop [スタッシュ名]

# 全作業を削除する
$ git stash clear
```