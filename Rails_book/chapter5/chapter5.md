# テストをはじめよう

**テストを書くことのメリット**
- テスト全体にかかるコストの削減
- 変更を加えやすくなる
- 環境のバージョンアップやリファクタリング の必須条件
- 仕様変更の影響の大きさを簡単に把握することができる
- 仕様を記述したドキュメントとしても機能する
- 仕様やインターフェースの理解に役立つ
- 適切な粗度のコードになりやすい
- 確実性を高めることで開発効率をあげる

**テストをより詳しく知りたい方向けの書籍**
「テスト駆動開発」

### テスト用ライブラリ

**RSpec**
RubyにおけるBDD(Behaviour-Driven Development: 振舞駆動開発)のためのテスティングフレームワーク
要求仕様をドキュメントに記述するような感覚でテストケースを記述することができる。

**Capybara**
WebアプリケーションのE2E(End-to-End)テスト用フレームワーク
MinitestやRSpecなどのテスティングライブラリと組み合わせて使う

**FactoryBot**
テスト用のデータの作成をサポートするgem

**本章で記述するテストの種類**
|分類|テストの種類|RSpecでの呼び方|
|---|---|---|
|全体的なテスト|システムテスト(System Test)<br>E2Eテストに総投資、ブラウザを通してアプリケーションの挙動を外部的に確認できる|System Spec<br>Feature Spec|
||結合テスト(Integration Test)<br>いろいろな昨日の連続が想定どおりに動くかを確認するテストで、システムよりも内部的な確認ができる|Request Spec|
||機能テスト(Function Test)<br>コントローラ単位のテスト|Controller Spec|
|個々の部品のテスト|モデル|Model Spec|
||ルーティング|Routing Spec|
||ビュー|View Spec|
||ヘルパー|Helper Spec|
||メーラー|Mailer Spec|
||ジョブ|Job Spec|

**準備**
Gemfile :development, :test 以下に gem 'rspec-rails' を追加
```
$ bin/rails g rspec:install
$ rm -r ./test
```
を実行