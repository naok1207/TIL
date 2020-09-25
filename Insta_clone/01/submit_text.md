# submitメッセージの変更方法について

**何をするか**
railsにおいてパーシャルを用いてformを共通化するのは当たり前のことである。
共通化した場合submitのテキストをどうすれば良いのかと言う疑問を持ったので解決する。

**解決方法**
yieldを用いて解決

```
# _form.html.slim

= f.submit yield(:button_text), class: "btn btn-primary"
```
```
# new.html.slim

- provide(:button_text, 'Sign Up')
= render 'form'
```
```
# edit.html.slim

- provide(:button_text, 'Update')
= render 'form'
```