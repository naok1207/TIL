# フォロー機能作成まとめ

## フロー
1. relationshipモデル作成
2. migrationファイル編集
3. アソシエーション記述
4. メソッド作成
5. コントローラー作成
6. view作成
7. ルーティング設定

## 1. relationshipモデル作成
```
$ rails g model Relationship
```

## 2. migrationファイル編集
```
class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      # follower フォロワー
      # followed フォローしたユーザ
      # follower(誰) から followed(誰) にフォローする
      # 存在しないテーブルのためinteger型を設定
      t.integer :follower_id, null: false
      t.integer :followed_id, null: false

      t.timestamps
    end
    # インデックスを設定
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # 一意制約を設定
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
```

## 3. アソシエーション記述
```
class Relationship < ApplicationRecord
  # class_name: 'User' 参照先をUserクラスであると明示する
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  # 一意制約を設定
  validates :follower_id, uniqueness: { scope: :followed_id }
end
```
```
class User < ApplicationRecord
  # :active_relationships followingの中間テーブルに用いる架空テーブル
  # class_name: 'Relationship'  参照先をrelationshipクラスであることを明示する
  # foreign_key: 'follower_id'  relationshipsテーブルにアクセスするときの入り口をfollower_idとする
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy

  # :passive_relationships followersの中間テーブルに用いる架空テーブル
  # class_name: 'Relationship'  参照先をrelationshipクラスであることを明示する
  # foreign_key: 'followed_id'  relationshipsテーブルにアクセスするときの入り口をfollowed_id'とする
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy

  # :following フォローしているユーザーを参照する架空テーブル
  # through: :active_relationships 中間テーブルを設定する
  # source: :followed 出口をfollowed_idとする
  has_many :following, through: :active_relationships, source: :followed
  # :followers フォロワーを参照する架空テーブル
  # through: :passive_relationships 中間テーブルを設定する
  # source: :follower 出口をfollower_idとする
  has_many :followers, through: :passive_relationships, source: :follower
end
```

## 4. メソッド作成
```
class User < ApplicationRecord
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # scope 可読性を高めるためにメソッドをまとめるために用いる
  # 登録日を新しい順に並べ変え引数の数だけ取り出すメソッド
  scope :recent, ->(count) { order(created_at: :desc).limit(count) }

  # フォローをするメソッド
  def follow(other_user)
    # following にユーザを格納することでcreateと同様の処理を実現している
    following << other_user
  end

  # フォローを外すメソッド
  def unfollow(other_user)
    # following から特定のユーザを削除する
    following.destroy(other_user)
  end

  # フォローを判定するメソッド
  def following?(other_user)
    # following に特定のユーザが含まれているか判定する
    following.include?(other_user)
  end
end
```

### following << other_user の詳細
```
pry(main)> User.first.following << User.second
  User Load (0.4ms)  SELECT  `users`.* FROM `users` ORDER BY `users`.`id` ASC LIMIT 1
  User Load (0.2ms)  SELECT  `users`.* FROM `users` ORDER BY `users`.`id` ASC LIMIT 1 OFFSET 1
   (0.1ms)  BEGIN
  User Load (0.2ms)  SELECT  `users`.* FROM `users` WHERE `users`.`id` = 1 LIMIT 1
  Relationship Exists (0.2ms)  SELECT  1 AS one FROM `relationships` WHERE `relationships`.`follower_id` = 1 AND `relationships`.`followed_id` = 2 LIMIT 1
  Relationship Create (0.3ms)  INSERT INTO `relationships` (`follower_id`, `followed_id`, `created_at`, `updated_at`) VALUES (1, 2, '2020-10-24 18:32:29', '2020-10-24 18:32:29')
   (1.3ms)  COMMIT
  User Load (0.4ms)  SELECT `users`.* FROM `users` INNER JOIN `relationships` ON `users`.`id` = `relationships`.`followed_id` WHERE `relationships`.`follower_id` = 1
```
1. `Relationship Exists`によりデータを確認する # 一意制約のため
2. `Relationship Create`によりデータを作成する

データが存在した場合は`Rollback`により処理を行わない

同様の動作をcreateを用いて記述した場合以下のようになる。
```
pry(main)> User.first.active_relationships.create(followed_id: User.second.id)
```


## 5. コントローラー作成
```
class RelationshipsController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
  end

  def destroy
    # Relationshipモデルよりidにより関係を取り出しfollowed_idに対応するユーザを取得する
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
  end
end
```

## 6. view作成
```
# フォローリンク
= link_to relationships_path(followed_id: user.id), class: 'btn btn-raised btn-outline-warning', method: :post, remote: true do
  | フォロー
```
```
# アンフォローリンク
= link_to relationship_path(current_user.active_relationships.find_by(followed_id: user.id)), class: 'btn btn-warning btn-raised', method: :delete, remote: true do
  | アンフォロー
```

## 7. ルーティング設定
```
Rails.application.routes.draw do
  resources :relationships, only: %i[create destroy]
end
```