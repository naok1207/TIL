# 現実の複雑さに対応する

**マイグレーション**
```
# バージョンあげる
$ rails db:migrate

# バージョン下げる
$ rails db:rollback
```
エラーが出たときはそれ以降のマイグレーションは適用されない

**データ型**
|データ型|説明|
|---|---|
|:boolean|真偽値|
|:integer|符号付き整数|
|:float|浮動小数点|
|:string|文字列(長い文字列)|
|:text|文字列(短い文字列)|
|:date|日付|
|:datetime|日時|

**NOT NULL制約**
データベーステーブルのカラムの値としてNULLを格納する必要が無い場合には、NOT NULL制約をつけることで、物理的にNULLを保存できないようにしてくれる。
```
$ bin/rails g migrateion ChangeTasksNameNotNull
```
```db/migrate/XXXXXXXXXXXX_change_tasks_name_not_null.rb:ruby
class ChangeTasksNameNotNull < ActionRecord::Migration[5.2]
    def change
        change_column_null :tasks, :name, false
    end
end
```
以下のように最初から追加することも可能
```
class CreateTasks < Migration[5.2]
    def change
        create_table :tasks do |t|
            t.string :name, null: false
            t.text :description
        end
    end
end
```

**カラムの長さを指定する**
```
def up
    change_column :tasks, :name, :string, limit: 30
end
def down
    change_column :tasks, :name, :string
end
```

**ユニーク**
```
def change
    add_index :tasks, :name, unique: true
end
```

**オリジナルの検証コードを書く**
方法
1. 検証を行うメソッドを追加して、そのメソッドを検証用のメソッドとして指定する
    あるモデル専用の処理を手軽に書く場合に適している
2. 自前のValidatorを作って利用する
    複数のモデルで共通利用したい汎用的な処理を書く場合に適している

1の方法で検証を追加するステップ
1. 検証用のメソッドをモデルクラスに登録する
2. 検証用のメソッドを実装する

ステップ１
```add/models/task.rb:ruby
validate :validate_name_not_includeing_comma
```

ステップ２
```app/models/task.rb:ruby
private

def validate_name_not_includeing_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
end
```

**コールバック**
「しかるべきタイミングがきたらこの処理を読んでください」という言葉
あとで読んで欲しい処理を予め指定しておく仕組みを示す用語


## 認証機能作成
**ユーザーモデルを作る**
|意味|属性名|データ型|
|---|---|---|
|名前|name|string|
|メールアドレス|email|string|
|パスワード|password_digest|string|

password_digest => パスワードのdigestという意味で、Railsに標準でついているhas_secure_passwordという機能を使ったときの命名ルールに沿った名前。
ハッシュ化を行なった文字列のこと

```
$ bin/rails g model user name:string email:string password_digest:string
```
この後マイグレーションファイルを修正
```
class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false

      t.timestamps
      t.index :email, unique:true
    end
  end
end
```
user.rb に has_secure_passwordを追記

**管理者**
```
$ bin/rails g migraion add_admin_to_users
```

migrationファイルを下記のように編集
```
class AddAdminToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin, :boolean, default: false, null: false
  end
end
```

管理用のコントローラを作成 admin/ 以下に users_controller が生成される
```
$ bin/rails g controller Admin::Users new edit show index
```

**チェックボックス**
```
.form-check
    = f.label :admin, class: 'form-check-input' do
        = f.check_box :admin, class: 'form-control'
```

**ログイン機能**
```
$ bin/rails g controller Sessions new
```
```config/routes.rb:ruby
Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  ...
end
```

**外部キーの追加**
```
@task = Task.new(task_params.merge(user_id: current_user.id))
```
```
@task = current_user.tasks.new(task_params)
```

**文字列に含まれるURLをリンクとして表示する**
```
gem 'rails_autolink'
```
rinkuというgemもある

