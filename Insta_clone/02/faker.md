# fakerについて

## fakerとは
画面の確認のためには一定数の投稿や、複数のユーザの投稿が必要。
そこでダミーデータを作成するためのgemのこと。

## 導入
**gem**
```
# Gemfile
group :development, :test do
    gem 'faker'
end
```

以下のようにすることでダミーデータを作成することができる。
```
$ bin/rails c
> Faker::Internet.email
=> "kaci@nolanfadel.org"
```

## seedsファイルの作成
通常ダミーデータを作成する際にはデフォルトで作成されるdb/seeds.rbというファイルに記述するが、
モデルが増えたりし、用途が増えた際に柔軟性にかけてしまうため、db/seeds/というディレクトリを作成し、
その中で複数のseedsファイルを管理できるようにする。
デフォルトでは`$ rails db:seed`というコマンドで実行するが個別に作成することができるように`$ rails db:seed:xxx`のようなコマンドが実行できるようなRakeタスクを追加する
```
$ rm db/seeds.rb
$ mkdir db/seeds/
```
```
# lib/tasks/seeds.rake

namespace :db do
    namespace :seed do
        Dir[Rails.root.join('db', 'seeds', '*.rb')].each do |filename|
         task_name = File.basename(filename, '.rb').intern
         task task_name => :environment do
            load(filename) if File.exist?(filename)
        end
    end
end
```

## ダミーデータ作成
```
# db/seeds/posts.rb

puts 'Start inserting seed "posts" ...'

3.times do |i|
    User.find_each do |user|
        puts "\"#{user.name}\" posted something!"
        user.posts.create({ body: Faker::Hacker.say_something_smart, user_id: user.id })
    end
end
```
```
$ rails db:seed:posts
```

## 使い方
rbファイルないでFaker::[ジャンル].[タイトル]のように入力することで利用することができる。

## FacrotyBotでの使い方
```
FactoryBot.define do

  factory :book do
    title     { Faker::Book.title }
    author    { Faker::Book.author }
    publisher { Faker::Book.publisher }
  end

end
```

## 参考
Ruby on Rails の上手な使い方
[公式リファレンス](https://github.com/faker-ruby/faker)
[【Rails】テストに使うダミーデータを用意する【Faker】](https://qiita.com/koki_73/items/60c2441fb873a8db35d5)
