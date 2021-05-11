# Active Record 関連付け
https://railsguides.jp/association_basics.html

## 関連付けついて
- 関連付け = アソシエーション = assosiation
- 2つのモデルの繋がりを表す

## 関連付けの種類
- belongs_to
- has_many
- has_many :through
- has_one :through
- has_and_belongs_to_many

### belongs_to
他方のモデルと「1対1」の繋がりが設定される
```rb
class Book < AppkicationRecord
  belongs_to :author
end
```
Book belongs to Author (本は著者のものです)
という関係になる

※ 関連を指定するモデル名は単数系

belongs_toの関連付けのマイグレーション
```
class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.timestamps
    end
  end

  create_table :books do |t|
    t.belongs_to :author
    t.datetime :published_at
    t.timestamps
  end
end
```

create_tableの内部でbelongs_toが設定されているのは初めてみた。
それならgeneratorでも設定できるのではないかと思い試した結果
```
$ rails g model book author:belongs_to published_at:datetime

class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.belongs_to :author, null: false, foreign_key: true
      t.datetime :published_at

      t.timestamps
    end
  end
end
```
NotNull制約とforeign_key制約が自動で付与されたのでreferencesとやってることとしては一緒みたい
明示的にどういう関係性を示しているのかが良い点のように思える。


### has_one
- 他方のモデルと「1対1」の関連付けを設定する
- 意味と結果は`belongs_to`とは若干異なる
- AごとにBが存在するような関係

```rb
class Supplier < ApplicationRecord
  has_one :account
end
```

一意制約を設定する場合もある
```rb
create_table :accounts do |t|
  t.belongs_to :supplier, index: { unique: true }, foreign_key: true
  # ...
end
```

### has_many
- 他のモデルとの間に「1対多」の関連付けを設定する
- 反対側のモデルでは多くの場合`belongs_to`が使われる
- book has_many comment 本が複数のコメントを持っているような関係
- モデル作成時referencesまたはbelongs_toにより関連付ける

```rb
class Book < AppliactionRecord
  has_many :comments
end
```

belongsにより関連を明示する場合
```rb
class Comment < ApplicationRecord
  belongs_to :book
end

> comment = Book.first.comments.first   #=> <Comment id: ..., ....>
> comment.book #=> <Book id: 1, ...., .....>
```

belongs_toにより関連を明示しない場合
```rb
class Comment < ApplicationRecord
end

> comment = Book.first.comments.first   #=> <Comment id: ..., ....>
> comment.book #=> NoMethodError undefined method `book'
```
この場合は片側からのみ参照が可能となるのでどこかしらで使い所があるかも？

### has_many :through
- 他方のモデルと「多対多」の繋がりを設定する場合によく使われる
- 2つのモデルの間に第3のモデル(joinモデル)(中間モデル)が介在する点が特徴
- A -> C -> B
- A <- C <- B

```rb
class Physician < ApplicationRecord
  has_many :appointments
  has_many :patients, :through => :appointments
end

class Appointment < ApplicationRecord
  belongs_to :physician
  belongs_to :patient
end

class Patient < ApplicationRecord
  has_many :appointments
  has_many :physicians, :through => :appointments
end
```

- A -> B -> C の関連づけも可能
- Documentに含まれるParagraphを全て取得する場合
```rb
class Document < ApplicationRecord
  has_many :sections
  has_many :paragraphs, through: :sections
end

class Section < ApplicationRecord
  belongs_to :document
  has_many :paragraphs
end

class Paragraph < ApplicationRecord
  belongs_to :section
end
```

### has_one :through
- 他方のモデルに対して「1対1」の繋がりを設定する
- A -> B -> C の関連
- A対B B対C を繋げて A対Cの関係を作成する
```rb
class Supplier < ApplicationRecord
  has_one :account
  has_one :account_history, through: :account
end

class Account < ApplicationRecord
  belongs_to :supplier
  has_one :account_history
end

class AccountHistory < ApplicationRecord
  belongs_to :account
end
```

### has_and_belongs_to_many
- 他方のモデルと「多対多」の繋がりを設定する
- throughとは異なり第３のモデル(joinモデル)(中間モデル)が介在しない代わりに結合用のテーブルが必要
```rb
class Assembly < ApplicationRecord
  has_and_belongs_to_many :parts
end

class Part < ApplicationRecord
  has_and_belongs_to_many :assemblies
end
```

Migration
```rb
class CreateAssembliesAndParts < ActiveRecord::Migration[5.0]
  def change
    create_table :assemblies do |t|
      t.string  :name
      t.timestamps
    end

    create_table :parts do |t|
      t.string :part_number
      t.timestamps
    end

    create_table :assemblies_parts, id: false do |t|
      t.belongs_to :assembly
      t.belongs_to :part
    end
  end
end
```
**??**
`create_tabel <テーブル名>, id: false`
これは初めてみた
idのレコードを作らずに作成することでモデルでないことを表してるのかな？
モデルとしては作成せずにテーブルとしてだけ存在させるということっぽい。


### belongs_to と has_one の使い分け
- has_one は所有しているの意味
- belongs_to は属しているの意味(所有されている)
- UserはProfileを所有している
- ProfileはUserに属している

**??**
#### トピック
外部キーの指定方法は2種類存在する
A. `t.bigint :user_id` 「モデル名_id」
B. `t.references :user`
Bの方が実装の詳細が抽象化され、隠蔽される

### has_many :through と has_and_belongs_to_many の使い分け
- `has_many` リレーションシップのモデルそれ自体を独立したエンティティとして扱いたい(両モデルの関係そのものについて処理を行いたい)場合
  - フォローの関係は独立した物体として用いたいからこっち
- `has_and_belongs_to_many` リレーションシップのモデルで何か特別なことをする必要がまったくない場合

### ポリモーフィック関連
- ある一つのモデルが他の複数のモデルに属していることを1つの関連付けで表現できる
- ポリモーフィックば`belongs_to`は他のあらゆるモデルから利用できるインターフェースを設定する宣言と見なすこともできる
```rb
class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true
end

class Employee < ApplicationRecord
  has_many :pictures, as: :imageable
end

class Product < ApplicationRecord
  has_many :pictures, as: :imageable
end
```
`@employee.pictures`とも`@product.pictures`ともすることができる
`@picture.imageable`とすることで親も取得できる

ポリモーフィックは二つのマイグレーションの書き方がある
```rb
class CreatePictures < ActiveRecord::Migration[5.2]
  def change
    create_table :pictures do |t|
      t.string  :name
      t.bigint  :imageable_id
      t.string  :imageable_type
      t.timestamps
    end
    add_index :pictures, [:imageable_type, :imageable_id]
  end
end
```
```rb
class CreatePictures < ActiveRecord::Migration[5.2]
  def change
    create_table :pictures do |t|
      t.string  :name
      t.references :imageable, polymorphic: true
      t.timestamps
    end
  end
end
```
外部キーのカラムと肩のカラムの両方を宣言する必要がある

ジェネレータで作成するなら
```rb
$ rails g model picture imageable:references{polymorphic}  name:string
```

### 自然結合
- 自分自身に関連付ける必要がある時に用いる
- 一つのモデルとしてまとめたいが上司とその部下を関連付け対場合など
```rb
class Employee < ApplicationRecord
  has_many :subordinates, class_name: "Employee",
                          foreign_key: "manager_id"

  belongs_to :manager, class_name: "Employee", optional: true
end
```
モデル自身にreferencesカラムを付与
```rb
class CreateEmployees < ActiveRecord::Migration[5.0]
  def change
    create_table :employees do |t|
      t.references :manager
      t.timestamps
    end
  end
```

## ヒントと注意事項
- キャッシュ制御
- 名前衝突の回避
- スキーマの更新
- 関連付けのスコープ制御
- 双方向関連付け

### キャッシュ制御
関連付けメソッドは、最後に実行したクエリの結果をキャッシュに保存し使い回す
```
author.books                 # データベースからbooksを取得する
author.books.size            # booksのキャッシュコピーが使われる
author.books.empty?          # booksのキャッシュコピーが使われる
```
データが更新された可能性がある場合には`relead`とすれば良い
```
author.books.reload.empty?   # booksのキャッシュコピーが破棄される
                             # その後データベースから再度読み込まれる
```

### 名前衝突の回避
railsで定義されているような識別子やメソッドを使って間違えてオーバーライドするなよって話

### スキーマの更新
has_and_belongs_to_manyではjoinテーブルを作成する際に`id: false`をしないと関連付けは正常に動作しない
join_tableを作成する方法は二つ

普通
```rb
class CreateAssembliesPartsJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table :assemblies_parts, id: false do |t|
      t.bigint :assembly_id
      t.bigint :part_id
    end

    add_index :assemblies_parts, :assembly_id
    add_index :assemblies_parts, :part_id
  end
end
```

`create_join_table`メソッドを利用
```rb
class CreateAssembliesPartsJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :assemblies, :parts do |t|
      t.index :assembly_id
      t.index :part_id
    end
  end
end
```

### 関連付けのスコープ制御
**??** どういう時に使うかがわからない
https://railsguides.jp/association_basics.html#%E9%96%A2%E9%80%A3%E4%BB%98%E3%81%91%E3%81%AE%E3%82%B9%E3%82%B3%E3%83%BC%E3%83%97%E5%88%B6%E5%BE%A1

### 双方向関連付け
`:inverse_of`
- foreign_keyやthroughにより関連付けする際には双方向の関連付けは自動ではされないためしっかりと関連付けを行う必要がある
```rb
class Author < ApplicationRecord
  has_many :books, inverse_of: 'writer'
end

class Book < ApplicationRecord
  belongs_to :writer, class_name: 'Author', foreign_key: 'author_id'
end
```

## 関連付けの詳細
### belongs_toで追加されるメソッド
- `association`
- `association=(associate)`
- `build_association(attributes = {})`
- `create_association(attributes = {})`
- `create_association!(attributes = {})`
- `reload_association`

これらのメソッドのうちassociationの部分は`belongs_to`の関連付け名をシンボルにしたものに置き換えられる
```rb
class Book < ApplicationRecord
  belongs_to :author
end
```
この場合は`association`が`author`に置き換えられ以下のようになる
```rb
author
author=
build_author
create_author
create_author!
reload_author
```

#### `association`
```
@author = @book.author
```
上の場合はキャッシュが存在すればそれを用いるが`reload_association`を用いることでデータベースから直接読み込ませることができる
```
@author = @book.reload_author
```

#### `association=(associate)`
関連付けをすることができる
オブジェクトから主キーを取り出し外部キーに設定する
```
@book.author = @author
```

#### 'build_association(attributes = {})'
- 関連付けられた型の新しいオブジェクトを返す
- 外部キーを持ち関連付けられた一時的なインスタンスが作成される
- あたいが返された時点ではデータは保存されていない

#### `create_association(attributes = {})`
- 関連付けられた型の新しいオブジェクトを返す
- 外部キーを持ち関連づけられたインスタンスが作成され、保存される

#### `create_association!(attributes = {})`
- 上と同じだが失敗すると例外が発生する

### belongs_toのオプション
- `:autosave`
- `:class_name`
- `:counter_cashe`
- `:dependent`
- `:foreign_key`
- `:primary_key`
- `:inverse_of`
- `:polymorphic`
- `:touch`
- `:validate`
- `:optional`

#### `:autosave`
- 親オブジェクトが保存されるたびに読み込まれている全てのメンバを保存し、destroyフラグが立っているメンバを破棄
- A -> B の関連が設定されている時 A を保存すると B も同時に保存される
**??**
- 一括で子要素を保存する際などに用いる？

#### `:class_name`
- 関連名から関連相手のオブジェクトが生成できない場合には`:class_name`オプションを用いてモデル名を直接指定できる
- A -> B という名前の関係を作りたいが モデル名では A -> C の関連の場合 `A belongs_to B class_name: C`とすることができる A.C -> A.B
```
class Book < ApplicationRecord
  belongs_to :author, class_name: "Patron"
end
```

#### `:counter_cache`
- 従属しているオブジェクトの__数__の検索効率を向上させる
- 従来であれば`@author.books.size`の値を知るためにSQLで`COUNT(*)`クエリを実行する必要があるがカウンタキャッシュを追加することでこの呼び出しを避けることができる
- `counter_cache: true` を `counter_cache: :count_of_books`とすることでカラム名を指定(オーバーライド)することができる
- `belongs_to`側で指定する

#### `:dependent`
- `:destroy` オブジェクトが削除される時、関連づけられたオブジェクトの`destroy`メソッドが実行される
- `:delete` オブジェクトが削除され時、関連付けられたオブジェクトが直接データベースから削除される. `destroy`メソッドは実行されない
  - `has_many`と関連している`belongs_to`に対して設定してはいけない
    - 孤立したレコードがデータベースに残る可能性がある

#### `:foreign_key`
- 外部キーを直接指定できる
- 外部キーは事前にマイグレーションで明示的に定義する必要がある

#### `:primary_key`
- 指定したからむを主キーとして設定できる
- usersテーブルにguidという主キーがあるとする場合外部から関連づける場合以下のようになる
```
class User < ApplicationRecord
  self.primary_key = 'guid' # 主キーがguidになる
end

class Todo < ApplicationRecord
  belongs_to :user, primary_key: 'guid'
end
```

#### `:inverse_of`
- 関連けの名前を指定できる
```
class Author < ApplicationRecord
  has_many :books, inverse_of: :author
end

class Book < ApplicationRecord
  belongs_to :author, inverse_of: :books
end
```

#### `:polymorphic`
- trueに指定するとポリモーフィック関連付けを指定できる

#### `:touch`
- saveやdestroyされた時、関連づけられたオブジェクトのupdated_atやupdated_onが更新される

#### `:validate`
- `true`関連づけられたオブジェクトが保存時に必ず検証される

#### `:optional`
- `true` 関連付けされたオブジェクトの存在性のバリデーションが実行されないようになる

### `belongs_to`のスコープ
- スコープブロックを用いてクエリをカスタマイズできる
```
class Book < ApplicationRecord
  belongs_to :author, -> { where active: true }
end
```

- `where`
- `includes`
- `readonly`
- `select`

#### `where`
- 関連付けられるオブジェクトが満たすべき条件を指定する
```rb
class Book < ApplicationRecord
  belongs_to :author, -> { where active: true }
end
```

#### `includes`
- 関連付けが行われる際にeager-loadしておきたい第二の関連付けを指定できる
- A -> B -> C の関連付けがされている際に A -> C の関連も一緒に指定するようなもの A.B.C の呼び出しが効率化される
- 間を挟まない直接の関連付けでは必要に応じて自動でeager-loadされるため設定する必要はない
- @chapter.book.autorのように直接取り出す頻度が高い場合はあらかじめchapterからbookへ関連付けを行うようにauthorをあらかじめincludesしておくと、無駄なクエリが減る
```rb
class Chapter < ApplicationRecord
  belongs_to :book, -> { includes :author }
end

class Book < ApplicationRecord
  belongs_to :author
  has_many :chapters
end

class Author < ApplicationRecord
  has_many :books
end
```

#### `readonly`
- 関連付けられたオブジェクトから読み出した内容は読み出し専用になる
- 関連ごと更新するような作業をしない場合に指定する

#### `select`
- 関連付けられたオブジェクトのデータ取り出しに使われるSQLのSELECT句を上書きする
- デフォルトでは全てのカラムを取り出す
- `select`を用いる場合`:foreign_key`オプションを必ず指定

### 関連付けられたオブジェクトが存在するかどうかを確認
- `association.nil?`メソッドを用いて、関連付けられたオブジェクトが存在するかどうかを確認
```
@book.author.nil?
```

## has_one 関連付け詳細
