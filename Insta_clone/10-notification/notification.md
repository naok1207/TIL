# 通知機能実装メモ

## 制約
- ポリモーフィック関連を使うこと
- ヘッダー部分の通知リストには最新の10件しか表示させないこと

## 概要
Activityモデルを作成し、ポリモーフィック関連を用いて複数のモデルに関連するモデルとする
関連するモデルでデータが追加された際に通知用のデータを作成する

## 流れ
- [Activityモデルを作成](#Activityモデルを作成)
- Activityモデルを編集
- ActivityControllerを作成
- 通知用のviewを作成
- 各通知機能を実装
  - コメント通知を実装
  - フォロー通知を実装
  - いいね通知を実装

## Activityモデルを作成
モデルを作成
```
$ rails g model activity subject:references{polymorphic} user:references action_type:intger read:boolean
```

migrationファイルを編集
```
class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      # ポリモーフィック関連により複数のモデルに関連した通知を作成する
      # subject_type: Model 関連モデルを示す
      # subject_id: Model.id モデルのデータを示す
      t.references :subject, polymorphic: true
      # 誰への通知かを示す
      t.references :user, foreign_key: true
      # 列挙定数によりどこからの通知なのか判断するのに用いる
      t.integer :action_type, null: false
      # 既読を判定する
      t.boolean :read, null: false, default: false

      t.timestamps
    end
  end
end
```

## Activity.rbを編集
- ポリモーフィックのリレーションを定義
- 列挙定数を定義
- メソッドを作成

```ruby
class Activity < ApplicationRecord
  # ルーティングをメソッドを利用するために読み込む
  # めっちゃあれ？routes合ってるのに...ってなりました。
  include Rails.application.routes.url_helpers

  # ポリモーフィックのリレーションを定義
  belongs_to :subject, polymorphic: true
  belongs_to :user

  scope :recent, ->(count) { order(created_at: :desc).limit(count)}

  # 列挙定数を定義
  # パラメータは名前定義で送られる(データは数値で格納される)
  enum action_type: { commented_to_own_post: 0, liked_to_own_post: 1, followed_me: 2 }
  enum read: { unread: false, read: true }

  # 通知からのリダイレクト先を定義
  def redirect_path
    # 名前定義で送られたデータをハッシュ値に変更
    case action_type.to_sym
    when :commented_to_own_post
      post_path(subject.post, anchor: "comment-#{subject.id}")
    when :liked_to_own_post
      post_path(subject.post)
    when :followed_me
      user_path(subject.follower)
    end
  end
end
```

## ActivityControllerを作成
コントローラを作成
```
$ rails g controller activities
```
```ruby
class ActivitiesController < ApplicationController
  def read
    # 通知を検索
    activity = current_user.activities.find(params[:id])
    # 既読済でない場合既読をつける
    # .read! enumの名前定義を書き換え(名前定義 + !)
    # .unread? enumの名前定義を確認(名前定義 + ?)
    activity.read! if activity.unread?
    # 通知が示すデータへアクセスする
    redirect_to activity.redirect_path
  end
end
```

## 通知用のviewを作成
- 通知一覧の取得用コントローラを定義
- 通知一覧のviewを作成
- 各通知のview partialを作成
#### 通知一覧の取得用コントローラを定義
mypage::activityコントローラを作成
```ruby
$ rails g controller mypage::activities index
```
コントローラを編集
```ruby
class Mypage::ActivitiesController < ApplicationController
  def index
    @activities = current_user.activities.order(created_at: :desc).page(params[:page]).per(10)
  end
end
```

#### 通知用headerアイコンを作成
headerに通知アイコンメニューを追加
```
# app/views/shared/_header.html.slim
li.nav-item
  .dropdown
    a#dropdownMenuButton.nav-link.position-relative href="#" data-toggle="dropdown" aria-expanded="false" aria-haspopup="true"
      = icon 'far', 'heart', class: 'fa-lg'
      = render 'shared/unread_badge'
    #header-activities.dropdown-menu.dropdown-menu-right.m-0.p-0 aria-labelledby="dropdownMenuButton"
      = render 'shared/header_activities'
```
headerのアイコンメニューパーシャルを作成
```
# app/views/shared/_header_activities.html.slim

- if current_user.activities.unread.count > 0
  span.badge.badge-warning.navbar-badge.position-absolute.rounded-circle style='top: 0; right:0;'
    = current_user.activities.unread.count
```
非既読の通知数を表示用パーシャルを作成
```
# app/views/shared/_unread_badge.html.slim

- if current_user.activities.unread.count > 0
  span.badge.badge-warning.navbar-badge.position-absolute.rounded-circle style='top: 0; right:0;'
    = current_user.activities.unread.count
```

#### 通知一覧のviewを作成
```
# app/views/mypages/activities/index.html.slim

/ 通知がある場合
- if @activities.present?
  - @activities.each do |activitiy|
    / action_typeにと同じ名前のpartialを取得し, オブジェクトを渡す
    = render "#{activity.action_type}", activity: activity
  = paginate @activities

/ 通知がない場合
- else
  .text-center
    | お知らせはありません
```

#### 各通知のview partialを作成
各通知の実装時に作成
- _commented_to_own_post.html.slim
- _followd_me.html.slim
- _liked_to_own_post.html.slim

## 通知用のルーティングを定義
```ruby
Rails.application.routes.draw do

  ...

  namespace :mypage do
    resources :accounts, only: %i[ edit update ]
    resources :activities, only: %i[ index ]
  end

  resources :activities, only: [] do
    patch :read, on: :member
  end
end
```

## 各通知機能を実装
- コメント通知を実装
- フォロー通知を実装
- いいね通知を実装

#### コメント通知を実装
Comment.rbの編集
```ruby
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # Activityモデルと関連を定義
  has_one :activity, as: :subject, dependent: :destroy

  validates :body, presence: true, length: { maximum: 100 }

  # トランザクション処理によりモデルが作成された場合のみコールバックを行う
  after_create_commit :create_activities

  private
  
  # コールバック用メソッド
  # 通知を作成する
  def create_activities
    Activity.create(subject: self, user: post.user, action_type: :commented_to_own_post)
  end
end
```
コメント通知用のview partialを作成
```
# app/views/mypages/activities/_commented_to_own_post.html.slim

= link_to read_activity_path(activity), class: "dropdown-item border-bottom #{'read' if activity.read?}", method: :patch do
  = image_tag activity.subject.user.avatar.url, class: 'rounded-circle mr-1', size: '30x30'
  object
    = link_to activity.subject.user.username, user_path(activity.subject.user)
  | があなたの
  object
    = link_to '投稿', post_path(activity.subject.post)
  | に
  object
    = link_to 'コメント', post_path(activity.subject.post, anchor: "comment-#{activity.subject.id}")
  | しました
  .text-right
    = l activity.created_at, format: :short

```

#### フォロー通知を実装
Relationship.rbを編集
```ruby
class Relationship < ApplicationRecord

  ...

  has_one :activity, as: :subject, dependent: :destroy

  after_create_commit :create_activities

  private

  def create_activities
    Activity.create(subject: self, user: followed, action_type: :followed_me)
  end
end
```
フォロー通知用のview partialを作成
```
# app/views/mypage/activities/_followed_me.html.slim

= link_to read_activity_path(activity), class: "dropdown-item border-bottom #{'read' if activity.read?}", method: :patch do
  = image_tag activity.subject.follower.avatar.url, class: 'rounded-circle mr-1', size: '30x30'
  object
    = link_to activity.subject.follower.username, user_path(activity.subject.follower)
  | があなたをフォローしました
  .text-right
    = l activity.created_at, format: :short
```

#### いいね通知を実装
like.rbを編集
```ruby
class Like < ApplicationRecord

  ...

  after_create_commit :create_activities

  private

  def create_activities
    Activity.create(subject: self, user: post.user, action_type: :liked_to_own_post)
  end
end
```

いいね通知用のview partialを作成
```
# app/views/mypage/activities/_liked_to_own_post.html.slim

= link_to read_activity_path(activity), class: "dropdown-item border-bottom #{'read' if activity.read?}", method: :patch do
  = image_tag activity.subject.user.avatar.url, class: 'rounded-circle mr-1', size: '30x30'
  object
    = link_to activity.subject.user.username, user_path(activity.subject.user)
  | があなたの
  object
    = link_to '投稿', post_path(activity.subject.post)
  | にいいねしました
  .text-right
    = l activity.created_at, format: :short
```

## 参考
[Active Record コールバック after_create_commit](https://railsguides.jp/active_record_callbacks.html)