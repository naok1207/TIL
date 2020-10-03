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

## 複数画像追加
carrierwaveを用いて複数画像を追加する際の変更点
```
# app/models/***.rb

mount_uploader :image, ImageUploader
=>
mount_uploaders :images, ImageUploader
```
```
# app/controllers/***_controllers.rb

private
def ***_params
    params.require(:***).permit(:***, images: [])
end
```
これらの変更のみでアップロードは可能となるが画像を以下のように読み込んでも表示されない

```
# app/views/***.html.slim

- @post.images.each do |image|
    image_tag image.url
```

**原因**
データベースに保存される際に画像が保存されたURLを正しくimage.urlに保存できていないため
```
> Post.first.images
# => ...
    images: "[\"IMG_0756.JPG\"]",
    ...
```
このように「"」が文字列として保存されてしまう

**改善方法**
モデルを作成するときにjson形式で作成する.
`serialize :JSON`で保存データをJSONに変換する