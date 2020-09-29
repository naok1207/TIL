# 設計

## 内容
- 投稿のCRUDを作ってください

## 手順
1. carrierwave, RMagickの導入
2. 投稿機能を実装, 画像は複数枚アップロード可能にする(Image_magickを使用して、画像は横幅or縦幅が最大1000pxになるようにリサイズ)
3. Swipterを使って画像をスワイプ可能にする。
4. seedファイルを作成し, fakerでダミーテキストを作成する

## モデル
Postモデル作成
Post
    description:string
    images:string
    references:user

後にCommentモデルを作成し、関連づける