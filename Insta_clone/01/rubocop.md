# rubocopとは
**rubocopとは**
コーディング規約に準拠しているかチェックするgem
インデントやメソッド名、改行などのチェックを行う。

gemを追加
```
group :development do
  gem 'rubocop', require: false
end
```

**.rubocop.yml**
Rubocopの設定ファイル。対象となるファイルの種類だったり、チャックする構文のデフォルトを変えたりと、自分たちのコーディングスタイルに沿った現実的なルールをこのファイルを適用する。

**.rubocop_todo.yml**
あまりに警告が多い時に`$ rubocop --auto-gen-config`を実行することにより自動生成される。
警告内容を全てこのファイルに一旦退避することができる。

実行
```
$ rubocop
```

**参考**
[RuboCop is 何？](https://qiita.com/tomohiii/items/1a17018b5a48b8284a8b)
[Rubocopチートシート](https://qiita.com/tanish-kr/items/abb881c098b3df3f9871)