 # qiita-markdown 導入 インプット まとめ

qiitaのmarkdownをrailsアプリケーションに対して導入するためにqiita-markdownというgemの導入を試す.

## 参考サイト
[qiita-markdownのインストール方法](https://qiita.com/jacoyutorius/items/9692434a9afe88a46e80)
[【Rails】Qiita::Markdownをインストールして使ってみる](https://qiita.com/noraworld/items/5984cdad9e7feedab594)

## gem導入
```Gemfile:ruby
gem 'qiita-markdown'
```
```
$ bundle install
```

エラー発生した後
```
$ brew reinstall icu4c
...

$ brew install cmake
```
これでエラーが解消された
元から
```
checking for gmake... no
checking for make... yes
checking for cmake... no
```
このように表示されておりcmakeがインストールされていないことが原因であった可能性もあるため
cmakeのインストールのみでよかった可能性がある.

### 絵文字の表示

```ruby:Gemfile
gem 'gemoji'
```

```
$ bundle install
$ bundle exec gemoji extract public/images/emoji
```

これで絵文字が表示されるようになる
```
:cat:
```

## ヘルパー作成
```ruby:application_helper.rb
module ApplicationHelper
  def qiita_markdown(markdown)
    processor = Qiita::Markdown::Processor.new(hostname: "example.com")
    processor.call(markdown)[:output].to_s.html_safe
  end
end

```

## view
```
qiita_markdown(memo.body)
```