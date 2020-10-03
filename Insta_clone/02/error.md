# 発生エラー

## "Explicit end statements are forbidden"
Rails + slim で開発中、明示的なendは必要ない
```
- end
```
記述してしまっていたためのエラー

## Can't resolve image into URL: undefined method `to_model'
carrierwaveにて画像投稿機能を実装中に遭遇した
理由としては画像へのURLが正しく出力できていなかったから。
```
# 修正前

image_tag @post.images
```
```
# 修正後

image_tag @post.images.url
```

以上