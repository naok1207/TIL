# bootstrap material design とは

**bootstrap material design とは**
Googleが提唱したWebデザインの手法であるマテリアルデザインをBootstrapのクラスを用いて実現したもの

**導入**
必要なパッケージのインストール
- Bootstrap本体のbootstrap
- Material Design for Bootstrapのbootstrap-material-design
- Bootstrapに必要なjquery
- これまたBootstrapに必要なpopper.js
```
$ yarn add bootstrap bootstrap-material-design
```

マニフェストファイルへ読み込み
```
# app/assets/javascripts/application.js

# 追記
//= require bootstrap-material-design/dist/js/bootstrap-material-design.js

```
```
# app/assets/stylesheets/application.scss

@import 'bootstrap-material-design/dist/css/bootstrap-material-design';
```

**jquery popper 導入**
```
# Gemfile

gem 'rails-jquery'
gem 'popper_js'
```
```
# app/assets/javascripts/application.js

//= require jquery3
//= require popper
```