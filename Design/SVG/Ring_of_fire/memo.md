## box-reflect
CSSベンダープレフィックスで機能するCSSの一つ
```
-webkit-box-reflect: 反射の方向 余白;
```
グラデーションを指定していない場合は100%反射となる.

|above|上に反射|
|---|---|
|below|下に反射|
|left|左に反射|
|right|右に反射|

```
-webkit-box-reflect: below 10px linear-gradient(transparent,transparent,#0002);
```

## transparent
透明の指定です。CSS3からでなはく、従来からあるプロパティの値です。透明度ではなく、transparentを指定すると、カラーが透明になります。
カラーのプロパティを無効化する。

#### おまけ
rgba()は、カラーの透明度の指定ができる値
rgba()は、カラーの指定ができるプロパティの値で使用できる
rgba()は、カラーコードではなく0〜255の10進数で指定する
rgb()という透明の指定がない値もある
transparentは、透明の指定ができる値
テキストを意図的に透明にして隠す行為は、検索サイトからペナルティを受ける

## box-shadow  inset
inset: 影がボックスの外側ではなく内側につくようになる

`,`で区切ることにより複数の影を指定できる
```
box-shadow: 0 0 50px #0f0, inset 0 0 50px #0f0;
```

## @keyframes 
```
.circle {
  animation: animate 時間 
}
```
keyframeについて
```
@keyframes 任意の名前 {
    0% {
        CSSプロパティ:値;
    }
    100% {
        CSSプロパティ:値;
    }
}
```

## animation
```
  animation: 名前 開始から終了までの時間 進行の度合い 開始時間 繰り返し回数 再生方向 開始前・終了後のスタイル 再生・停止;
```
無限: infinite

animationプロパティの場合複数のアニメーションを指定できる
```
animation: fadeIn 3s, fadeOut 3s 5s forwards;
```

|No|プロパティ|読み方|説明|
|---|---|---|---|
|01|animation-name|アニメーション・ネーム|アニメーションの名前|
|02|animation-duration|アニメーション・デュレーション|アニメーションが始まって終わるまでの時間を指定します。|
|03|animation-timing-function|アニメーション・タイミング・ファンクション|アニメーションの進行の度合いを指定します。|
|04|animation-delay|アニメーション・ディレイ|アニメーションが始まる時間を指定します。|
|05|animation-iteration-count|アニメーション・イテレーション・カウント|アニメーションの繰り返し回数を指定します。|
|06|animation-direction|アニメーション・ディレクション|アニメーションの再生方向を指定します。|
|07|animation-fill-mode|アニメーション・フィル・モード|アニメーションの開始前、終了後のスタイルを指定します。|
|08|animation-play-state|アニメーション・プレイ・ステート|アニメーションの再生・停止を指定します。|
|09|animation|アニメーション|上記、8つのプロパティを一括で指定できる、ショートハンドプロパティです。|

[【CSS3】@keyframes と animation 関連のまとめ](https://qiita.com/7968/items/1d999354e00db53bcbd8)