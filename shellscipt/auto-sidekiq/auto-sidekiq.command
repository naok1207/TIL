#!/bin/bash

BASH_DIR=`dirname $0`

# gemを追加
cat ./Gemfile $BASH_DIR/assets/gems > ./Gemfile
bundle install

# queue_adapter を設定に追記
cat ./config/application.rb | tac | sed -e "2r $BASH_DIR/assets/application.rb" | tac

# sidekiqの設定ファイルを作成
cp $BASH_DIR/assets/sidekiq.rb ./config/initializers/sidekiq.rb

# sidekiq.ymlを作成
cp $BASH_DIR/assets/sidekiq.yml ./config/sidekiq.yml

# 設定を反映して起動
bundle exec sidekiq -C config/sidekiq.yml -d

# ルーティング追加
cat ./config/routes.rb | tac | sed -e "1r $BASH_DIR/assets/routes.rb" | tac