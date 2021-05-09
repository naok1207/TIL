# テストコマンド

**application.rbの下から3行目に文字を追加**
`cat test/application.rb | tac | sed -e '2r assets/application.rb' | tac`