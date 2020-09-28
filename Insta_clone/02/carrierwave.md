# carrierwaveとは

## carrierwaveとは
Railsで開発webアプリに、画像をアップロードする機能を付与する時に用いるgem

## 導入
**gemのインストール**
```
# Gemfile

gem 'carrierwave'
```

**uploader作成**
uploaderを作成
userモデルに`avatar_path`カラムを作成
```
$ bin/rails generate uploader Avatar
$ bin/rails generate scaffold User name:string avatar_path:string
$ bin/rails generate db:migrate
```

**モデルの修正**
`:avatar_path`と`Avatar`を関連づける
```
# app/models/****.rb

class User < ApplicationRecord
    mount_uploader :avatar_path, AvatarUploader
end
```

**ビューを修正**
```
# app/view/users/_form.html.slim

.form-group
    = f.lavel :avatar_path
    = f.file_field :avatar_path, id: :user_avatar_path
```
```
# app/view/users/show.html.slim

p= @user.avatar_path
= image_tag @user.avatar_path
```