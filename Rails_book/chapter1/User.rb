class User
    # インスタンス変数
    attr_accessor :name, :adress, :email

    # --- 以下と同じ ---
    # def name=(name)
    #     @name = name
    # end

    # def name
    #     @name
    # end
    # --- ここまで ---

    # メソッド
    def profile
        "#{name} #{adress}"
    end
end

# irb
# > require './user.rb'