# turbolinksとは

**turbolinksとは**
Rails4からデフォルトで導入された機能で、Ajaxとhistory API を使用して高速で画面遷移させる仕組み

**問題**
$(document).ready() や $(window).load() が発火しないなど様々な制約が発生する
これによりjavascriptがうまく動作しないといった問題が発生する
最初にページを読み込んだ時にはイベントを発生させるが、ページ遷移した時には発生させないことから起こる。

**turbolinks無効化(アプリケーション作成)**
--skip-turbolinksを作成時に付ける
```
$ rails new . --skip-turbolinks
```

**turbolinks無効化(ソースコード)**
jsの再読み込みなどに関してturbolinksによるリンクに問題が生じた場合は、特定のリンクのみ、この機能を無効化できる。
無効化状態は、対象の<a>タグかその親のタグに、data-turbolinksを指定することで制御できる。
```html:直接無効化する
<a href="..." data-turbolinks="false">turbolinksを使わずにリンクする</a>
```
```html:親によって無効化する
<div data-turbolinks="false">
  <a href="...">...</a>
</div>
```

**turbolinksの動作**
1.リンクのclickイベントをフック
2.リンク先のページをXHRで取り寄せる
3.レスポンスをDOM化
4.現在のページと取り寄せたページの外部JavaScriptファイルとCSSファイルが同一なら、titleとbodyを読み込んだページのもので置き換える
DOM構造を利用してjavascript・cssファイルを変更しないことにより画面遷移を高速化させる?
この時javascriptは読み込まれないためイベントが発生しない。

turbolinksは同じドメインのすべてのa hrefタグのクリックを横取りしている
TurbolinksはブラウザのurlをHistoryAPIを使って変えている
XMLHttpRequestを使って新しいページをリクエストしてHTMLを返している


## 参考
[turbolinksの仕組み](https://qiita.com/morrr/items/54f4be21032a45fd4fe9)