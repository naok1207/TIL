# 環境構築 (mac)

**rbenv**
Rubyの管理が簡単になる
複数のバージョンのRubyを自在に切り替えることができるようになる

```
# Homebrew を利用するため Command Line Tools for Xcode をインストール
$ xcode-select --install

# xcodeのインストールを確認
$ xcodebuild --version

# https://brew.sh/index_ja よりインストールスクリプトをコピーし Homebrew をインストール
$ /usr/bin/ruby -e "$(curl -fSL https://raw.githubusercontent.com/Homebrew/install/master/install)" # 例

# Homebrew のインストールを確認
$ brew doctor

# rbenv のインストール
$ brew install rbenv

# rbenv コマンド設定
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
$ echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

# rbenv 確認
$ rbenb -v

# ruby インストール
$ ruby install 2.5.1

# ruby 確認
$ ruby -v
$ which ruby

# RubyGems のアップデート
$ gem update --system

# gem の一覧を確認
$ gem list
```

**Rails**
```
# Rails のインストール
$ gem install rails -v 5.2.1

# Rails 確認
$ rails -v
```

**Node.js**
フロントエンド開発においてjavascriptを用いる場合、効率よく配信するためにjavascriptを圧縮するのが一般的であり、
railsにも標準で機能が備わっているが、javascriptランタイムが必要となるため、インストール
```
# Node.js のインストール
$ brew install node
```

**データベース**
データの永続化のために使うデータベース
```
# Postgresql のインストール
$ brew install postgresql

# Postgresql 確認
$ postgres -V

# postgresql の起動
$ brew services start postgresql

# postgresql の停止
$ brew services stop postgresql

# postgresql の動作確認
$ psql postgres
```