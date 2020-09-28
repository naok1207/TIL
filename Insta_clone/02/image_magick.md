# image_magickについて

## image_magickとは
コマンドラインから画像処理を可能にするツール
多くの画像ファイル形式に対応しており、サイズの変更や画像の合成、画像の分析、画像の作成などができる

## RMagickとは
ImageMagickをRubyで扱えるようにしたgemであり、Ruby用のImageMagickインターフェースのこと

## 導入
**ImageMagickのインストール**
```
$  brew install imagemagick@6  (Macの場合)

$  sudo apt-get install  imagemagick  (Ubuntuの場合)
```

**pkg-config**
```
$ brew install pkg-config
```

**パスを通す**
```
$ export PKG_CONFIG_PATH=/usr/local/opt/imagemagick@6/lib/pkgconfig
```

**gemのインストール**
```
# Gemfile

gem 'rmagick'
```

## 使い方
画像を読み込む方法
```
image = Magick::Image.read('画像の名前').first
```

画像をリサイズする方法
```
# 元画像の画像サイズは1000x700とします。

image = image.resize_to_fit(700, 70)

#=>小さい方の120にリサイズされます。

(100,70)へリサイズされます。
```

**正方形サムネイルの作成**
```
def create_square_image(rmagick, size)
  narrow = rmagick.columns > rmagick.rows ? rmagick.rows : rmagick.columns
  rmagick.crop(Magick::CenterGravity, narrow, narrow).resize(size, size)
end
```

## 参考
[RubyでRMagickを利用して画像処理する方法を現役エンジニアが解説【初心者向け】](https://techacademy.jp/magazine/19896)
[RMagick で正方形のサムネイルを作成する](https://qiita.com/9m/items/0e551093ca06a9986fbf)
[【Rails】CarrierWaveとRMagickでいい感じにサムネイルをつくる](https://qiita.com/hakusai_it/items/fdd1561097645e10cdd5)