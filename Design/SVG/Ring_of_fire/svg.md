# SVGについて

## SVGフィルタ

### <filter>要素
SVGフィルタ専用要素
要素は直接レンダリングされず、SVGではfilter属性と一緒に、またはCSSではurl()機能と一緒に使用される
```
# SVGフィルタを定義し、ソース画像に適用するためのごく基本的で、シンプルなサンプルコード
<svg width="600" height="450" viewBox="0 0 600 450">
    <filter id="myFilter">
        <!-- filter effects go in here -->
    </filter>
    <image xlink:href="..." 
           width="100%" height="100%" x="0" y="0"
           filter="url(#myFilter)"></image>   
</svg>
```
このコードだけではフィルタは反映されない。
フィルタ効果を作成するには, filter要素内で効果を発揮するフィルタ操作を1つ以上定義する必要がある。
filter要素はあくまでも入れ物
filter要素に入れるフィルタ効果を作り出すフィルタ操作を「フィルタプリミティブ」とよぶ。

### フィルタプリミティブ
各フィルタプリミティブが１つ以上のインプットに対し基本的な画像操作を実行し、グラフィカルな結果を演出する。
フィルタプリミティブは17種類存在し、全てのプリミティブにはfe (「filter effect」の略) というプレフィックスがつく

|入力||
|---|---|
|feFlood|カラーフィールドを生成する|
|feTurbulence|さまざまなノイズ効果を生成します。|
|feImage|外部画像参照、データURIまたはオブジェクト参照から画像を生成する（12月中旬の時点でオブジェクト参照はFirefoxではサポートされていない）|

|変換||
|---|---|
|feColorMatrix|RBGAピクセルの入力値を出力値に変換する|
|feComponentTransfer|個々のカラーチャンネルのカラーカーブを調整する|
|feConvolveMatrix|各ピクセルを、現在のピクセルを基準とする領域のピクセル値から計算された新しいピクセルに置き換えます。|
|feGaussianBlur|現在のピクセルを、ピクセルの周りの領域のピクセルの加重平均で置き換えます|
|feDisplacementMap|別の入力グラフィックのR、G、またはB値に基づいて各ピクセルを現在の位置から移動します。|
|feMorphology|各ピクセルを、そのピクセルの周りの矩形領域内のすべてのピクセルの最大値または最小値から計算された新しいピクセル|に置き換えます。
|feOffset|入力を現在の位置から移動する|

|照明効果||
|---|---|
|feSpecularLighting|「輝く」2Dまたは擬似3D照明効果を提供します|
|feDiffuseLighting|「マット」2Dまたは擬似3D照明効果を提供します。|
|feDistantLight|鏡面反射または拡散照明のための遠隔光源を提供する|
|feSpotLight|鏡面または拡散照明用の円錐断面光源を提供します。|
|fePointLight|鏡面反射または拡散照明のための点光源を提供する|

|組み合わせ||
|---|---|
|feMerge|複数の入力から以前のフィルタ入力を含むシンプルなコンポジットを作成します。|
|feBlend|混合ルールを使用して複数の入力を混合する|
|feComposite|アルファ値を考慮して、設定された組み合わせルールを使用して複数の入力を組み合わせます。|
|feTile|入力を繰り返して繰り返しパターンを作成する|

今回利用したfeTurbulenceはさまざまなノイズ効果を生成する。

**feTurbulence**
|オプション|意味|
|---|---|
|type|Turbulenceでゆらぎ関数FractalNoiseノイズの関|数を指定できます。
|baseFrequency|ノイズの粗さを調整。|
|numOctaves|ノイズ関数に対するオクターブ、大きくなるほ|どより複雑になる。
|seed|乱数の種。|
|stitchTiles|継ぎ目の処理方法を設定できます。stitch|で継ぎ目をつなぐ、noStitchでつながない。
|result|他の効果とつなげるための名前の設定。|

**animate要素**
animate 要素は１個の属性／プロパティに対する時経過に伴うアニメーションに用いられる。 例えば、矩形を５秒間で薄れ消し去るようにするには、次のように指定する：
```
<rect>
  <animate attributeType="CSS" attributeName="opacity" 
         from="1" to="0" dur="5s" repeatCount="indefinite" />
</rect>
```

## 参考
[SVGフィルタ](https://riptutorial.com/ja/svg/topic/3262/%E3%83%95%E3%82%A3%E3%83%AB%E3%82%BF)

[SVG アニメーション](https://triple-underscore.github.io/SVG11/animate.html#AnimateElement)