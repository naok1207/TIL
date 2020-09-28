# Swiperについて

## Swipterとは
CSSとJSを適用することで、画像などをスライドできる機能を実装するもの

## 導入
**CDNから読み込む方法**
```
# application.html.slim

/Swiperの全ての機能を使いたい方はこちらを使用
= stylesheet_link_tag "https://unpkg.com/swiper/swiper-bundle.css"
= javascript_include_tag "https://unpkg.com/swiper/swiper-bundle.min.css"

/最小限の機能で構わない！ CSSやJSのファイルが小さい方がいい！ という方はこちらを使用
/最小限の機能が何かまでは調べられていないので、公式を参照するなり、通常版と比較考慮するなどしてみてください
= stylesheet_link_tag "https://unpkg.com/swiper/swiper-bundle.min.css"
= javascript_include_tag "https://unpkg.com/swiper/swiper-bundle.min.js"
```

## 参考
[RailsでSwiperを導入する方法（Swiperは2020年7月にバージョンアップし、従来と設定方法が変わりました！）](https://qiita.com/miketa_webprgr/items/0a3845aeb5da2ed75f82#:~:text=Swiper%E3%81%A8%E3%81%AF,%E3%82%92%E5%AE%9F%E8%A3%85%E3%81%99%E3%82%8B%E3%82%82%E3%81%AE%E3%81%A7%E3%81%99%E3%80%82)
[スライダープラグイン Swiper（v5）の使い方](https://www.webdesignleaves.com/pr/plugins/swiper_js.html)
[公式](https://swiperjs.com/)
[公式:Swipter入門](https://swiperjs.com/get-started/)
[公式:SwipterAPI](https://swiperjs.com/api/)