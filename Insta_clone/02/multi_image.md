# 複数画像の登録方法について

## 投稿
`accepts_nested_attributes_for`を記述して、formでimageを同時投稿できるようにする。
```
# models/product.rb

class Product < ApplicationRecord
    has_many :images. dependent: :destroy
    accept_nested_attributes_for :images
end
```
```
# models/image.rb

class Image < ApplicationRecord
    mount_uploader :image, ImageUploader
    belongs_to :product
end
```

```
# controllers/products_controller.rb
def new
    @product = Product.new
    @product.images.build
end

...

private
def product_params
    params.require(:product).permit(
        :name,
        :description,
        :period,
        :price,
        category_ids: [],
        images_attributes: [:name, :id],
    )
    .merge(user_id:current_user.id)
end
```

```
# products/new.html.slim

= form_with model: @product do |f|
    = f.fields_for :images do |image|
        = image.file_field :name
```


## 参考
[【Rails】画像の複数登録＋プレビュー表示](https://qiita.com/manbolila/items/57ffeb8937804b9ce049)