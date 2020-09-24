# sorceryとは

**sorceryとは**
ユーザ認証機能を簡単に実装できるライブラリで、MITライセンスのオープンソースソフトウェアとして公開されている。

ユーザ認証の基本的な機能であるパスワード認証を始め、
- User Activation
- Reset Password
- Remember Me
- Session Timeout
- Brute Force Protection
- Basic HTTP Authentication
- Activity Logging
といった機能が揃っている。

### パスワード認証機能を実装する

**sorceryの導入**
```
gem 'sorcery'
```

**設定済みメソッド**
|メソッド名|機能|
|---|---|
|require_login|認証判定を行う|
|not_authenticated|認証しなかった場合の処理. 自身で記述して利用|
|login(email, password, remember_me = false)|認証を行う|
|auto_login(user)|資格情報なしでログイン|
|logout|ログアウトを行う|
|logged_in?|認証判定を行う|
|current_user|認証済みユーザーを返す|
|redirect_back_or_to(url)|認証判定前のページへ戻る。なければ指定urlへ行く。|
|@user.external?|Facebookまたはtwitterにより登録しているか判定する。|
|@user.active_for_authentication?||
|require_login_from_http_basic||
|login_at(provider)||
|login_from(provider)||
|create_from(provider)||
|build_from(provider)||
|auto_login(user, should_remember = false)||
|remember_me!||
|forget_me!||
|force_forget_me!||
|User.load_form_reset_password_token(token)||
|@user.generate_reset_password_token!||
|@user.deliver_reset_password_instructions!||
|@user.change_password(new_password)||
|@user.change_password!(new_password)||
|invalidate_active_sessions!||
|User.load_from_activation_token(token)||
|@user.setup_activation||
|@user.activate!||

**Userモデル作成**
`bundle exec rails g sorcery:install` を実行.
以下のファイルが生成される.
- app/models/user.rb
- config/initializers/sorcery.rb
- db/migrate/yyyymmddhhmmss_sorcert_core.rb
```
$ bundle exec rails g sorcery:install
$ bundle exec rails db:migrate
```

user.rbはには`authenticates_with_sorcery!`メソッドが記述される。
```ruby
# app/model/user.rb
class User < ApplicationRecord
    authenticates_with_sorcery!
end
```

**User登録機能を実装**
基本的なviewとcontrollerを生成
...

**認証機能を実装**
ルーティングを設定
sessionコントローラーを生成
sessionビューを生成

**認証済み判定処理**
application_controller.rbへ`require_login`メソッドをbefore_actionに指定
controller全体を認証が必要なページに設定する

認証されていない場合の処理も合わせて実装する必要があり、デフォルトでは`not_authenticated`と言うメソッドを実行するため、この名前で実装する。
他のメソッドを指定する場合は、config/initializers/sorcery.rbを編集して変更する。
```
# app/controllers/application_controller.rb
before_action :require_login

protected

def not_authenticated
    redirect_to root_path
end
```

このままでは、ログインページ自体もにも認証判定が機能してしまうため認証判定が不要なコントローラーでは、
skip_before_actionにより`require_login`メソッドをスキップする。
```
# app/controllers/sessions_controller.rb
skip_before_action :require_login, except: [:destroy]
```

sessionコントローラー編集
`login(email, password)`メソッドにより認証を行う
```
# app/controllers/sessions_controller.rb
def create
    @user = login(params[:email], params[:password])
    if @user
        redirect_back_or_to(root_path)
    else
        render :new
    end
end
```

`logout`メソッドによりログアウト処理を行う
```
# app/controllers/sessions_controller.rb
def destory
    logout
    redirect_to root_path
end
```


**参考**
[Rails+Sorceryで認証処理を実装する](https://www.sglabs.jp/rails-sorcery/)
[Sorcery/sorcery Github](https://github.com/Sorcery/sorcery)
[シンプル認証gem sorceryを完全入門するで！！](https://qiita.com/babashunsu/items/9937b0a2e08d318edece)