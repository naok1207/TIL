# RailsのためのRuby入門

**万物がオブジェクト**
全てのものがオブジェクト

**irb**
rubyの実行結果を確認することができる対話的な実行環境

**オブジェクト**
オブジェクトの固有番号を確認する。
中身が同じオブジェクトのIDは全て一緒
```
.object_id # オブジェクト確認用メソッド
```

**モジュール**
モジュールのオブジェクトは生成できない
```
module Chatting
    def chat
        "hello"
    end
end

# includeメソッドを利用してクラスに取り込む
class Dog
    include Chatting
end

> dog = Dog.new
> dog.chat # => "hello"

```

**nilガード**
```
number ||= 10
```

**ぼっち演算子**
nilに対してメソッドを利用してもエラーにならない
```
> object = nil
> object&.name
# => nil
```

**配列から指定要素のみを取り出す**
```
names = []

users.each do |user|
    names << user.name
end
```
```
names = users.map do |user|
    user.name
end
```
```
names = users.map { |user| user.name }
```
```
names = users.map(&:name)
```
&はprocメソッドを呼び出す演算子