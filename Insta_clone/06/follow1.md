# フォロー機能作成方法まとめ

## フロー
1. relationshipsモデル作成
2. migrationファイルを編集
3. relationshipsモデルとuserモデルのアソシエーションを記述
4. userモデルにフォロー用メソッドを記述
5. relationshipsコントローラーを作成
6. viewを編集
7. ルーティングを記述

## 1. relationshipsモデル作成
```
$ rails g model Relationship
```

## 2.migrationファイルを編集
```
class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      # 外部キー設定
      t.references :user, foreign_key: true
      # 外部キー設定
      # 参照先がデフォルトだとfollowsテーブルなので {to_table: :users} とし、usersテーブルを参照する
      t.references :follow, foreign_key: { to_table: :users }

      t.timestamps

      # 一意制約
      t.index [:user_id, :follow_id], unique: true
    end
  end
end
```
マイグレーションファイルを実行
```
$ rails db:migrate
```

## 3. relationshipsモデルとuserモデルのアソシエーションを記述
```
class Relationship < ApplicationRecord
    belongs_to :user
    # class_name: 'User' 参照先をUserクラスであることを明示する
    belongs_to :follow, class_name: 'User'

    validates :user_id, presence: true
    validates :follow_id, presence: true
end
```

```
class User < ApplicationRecord
    has_many :relationships
    # :followings   フォローしているユーザーを参照する架空モデル
    # through:      :relationshps 中間テーブルを設定
    # source:       :follow relationshipsテーブルのfollow_idを参照し, followingsモデルにアクセスする
    # user_id -> follow_id の方向によりユーザを取得
    has_many :followings, through: :relationships, source: :follow
    # :reverse_of_relationships     relationshipsテーブルを逆方向に参照する架空モデル
    # class_name: 'Relationship'    参照先をrelationshipクラスであることを明示する
    # foreign_key: 'follow_id'      relationshipsテーブルにアクセスするときの入り口をfollow_idとする
    has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
    # :followers    フォロワーを参照する架空テーブル
    # through: :reverse_of_relationships    中間テーブルを設定
    # source: :user 出口をuser_idとする
    # follow_id -> user_id の方向によりユーザを取得
    has_many :followers, through: :reverse_of_relationships, source: :user
end
```
foreign_key = 入り口, source = 出口
参照する方向を指定することができる

## 4. userモデルにフォロー用メソッドを記述
```
class User < ApplicationRecord
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user

  # フォローをするメソッド
  def follow(other_user)
    # other_userが自分自身でないかを検証
    unless self == other_user
      # find_or_create_by 見つかればオブジェクトを返し, 見つからなければ作成する
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  # フォローを外すメソッド
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  # フォローを判定するメソッド
  def following?(other_user)
    # フォローしているユーザ全体を取得し, other_userが含まれていないかを確認
    self.followings.include?(other_user)
  end

end
```

## 5. relationshipsコントローラーを作成
```
class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:follow_id])
    current_user.follow(@user)
  end

  def destroy
    @user = User.find(params[:follow_id])
    current_user.unfollow(@user)
  end
end
```

## 6. viewを編集
非同期viewを作成

## 7. ルーティングを記述
```
Rails.application.routes.draw do
  resources :relationships, only: [:create, :destroy]
end
```

## 参考
[Railsでフォロー機能を作る方法](https://qiita.com/mitsumitsu1128/items/e41e2ff37f143db81897)