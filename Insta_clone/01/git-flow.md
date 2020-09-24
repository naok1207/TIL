# git-flowとは

### branch

**master**
リリース可能な状態の別のブランチをマージするブランチ
このブランチを直接修正することはない

**develop**
開発段階の中心ブランチ
このブランチを直接修正することはない
基本的にことブランチをfeatureブランチを切って開発を進めていく

**feature**
開発者が直接コードを修正するブランチ
developブランチからブランチを切り開発を進めていく
developブランチへプルリクエストを送り、レビューを送り、マージする
developブランチにマージされたらfeatureブランチは不要になる

**hotfix**
緊急でバグを修正する必要がある場合に利用するブランチ
masterブランチよりブランチを切りmasterブランチへマージする

**release**
developブランチにいくつかのfeatureブランチがマージされリリースの準備が整ったらこのブランチを作成する
masterブランチへマージする
ステージング環境でバグが発見されたらdevelopブランチへもマージする
問題がなければreleaseブランチからmasterブランチにマージして本番環境にもデプロイする(capistranoなどを使って自動でデプロイすることが多い)

### 準備手順
以下のコマンドで git-flow をインストール
```
$ brew insatll git-flow
```

1.プロジェクトの初期化をする
対象のプロジェクトディレクトリへ行きコマンドを実行
質問に対してEnterを入力し進む
masterブランチ、developブランチが自動的に作られる
```
$ git flow init
Initialized empty Git repository in /Users/daichisaito/git-flow-example/.git/
No branches exist yet. Base branches must be created now.
Branch name for production releases: [master] 
Branch name for "next release" development: [develop] 

How to name your supporting branch prefixes?
Feature branches? [feature/] 
Release branches? [release/] 
Hotfix branches? [hotfix/] 
Support branches? [support/] 
Version tag prefix? [] 
```

2.featureブランチを作る
```
$ git flow feature start branch-a
Switched to a new branch 'feature/branch-a'

Summary of actions:
- A new branch 'feature/branch-a' was created, based on 'develop'
- You are now on branch 'feature/branch-a'

Now, start committing on your feature. When done, use:

     git flow feature finish branch-a
```

主に初期設定終了済のアプリケーションに行う