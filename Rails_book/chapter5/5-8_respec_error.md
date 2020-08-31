以下のエラーが発生した
```
$ bundle exec rspec spec/system/tasks_spec.rb
2020-08-30 19:11:37 WARN Selenium [DEPRECATION] Selenium::WebDriver::Chrome#driver_path= is deprecated. Use Selenium::WebDriver::Chrome::Service#driver_path= instead.
Capybara starting Puma...
* Version 3.12.6 , codename: Llamas in Pajamas
* Min threads: 0, max threads: 4
* Listening on tcp://127.0.0.1:63236
F

Failures:

  1) タスク管理機能 一覧表示機能 ユーザーAがログインしているとき ユーザーが作成したタスクが表示される
     Got 0 failures and 2 other errors:

     1.1) Failure/Error: visit login_path
          
          Selenium::WebDriver::Error::SessionNotCreatedError:
            session not created: This version of ChromeDriver only supports Chrome version 85
          
          
          
          # 0   chromedriver                        0x0000000106d5f1b9 chromedriver + 4911545
          # 1   chromedriver                        0x0000000106cfee03 chromedriver + 4517379
          # 2   chromedriver                        0x000000010696cdc6 chromedriver + 773574
          # 3   chromedriver                        0x00000001068c8452 chromedriver + 99410
          # 4   chromedriver                        0x00000001068c4d6f chromedriver + 85359
          # 5   chromedriver                        0x00000001068f3716 chromedriver + 276246
          # 6   chromedriver                        0x00000001068f0723 chromedriver + 263971
          # 7   chromedriver                        0x00000001068ca720 chromedriver + 108320
          # 8   chromedriver                        0x00000001068cb693 chromedriver + 112275
          # 9   chromedriver                        0x0000000106d27f72 chromedriver + 4685682
          # 10  chromedriver                        0x0000000106d35b3a chromedriver + 4741946
          # 11  chromedriver                        0x0000000106d35801 chromedriver + 4741121
          # 12  chromedriver                        0x0000000106d0b25e chromedriver + 4567646
          # 13  chromedriver                        0x0000000106d36061 chromedriver + 4743265
          # 14  chromedriver                        0x0000000106d1cd0a chromedriver + 4640010
          # 15  chromedriver                        0x0000000106d4f0ba chromedriver + 4845754
          # 16  chromedriver                        0x0000000106d65387 chromedriver + 4936583
          # 17  libsystem_pthread.dylib             0x00007fff6f532109 _pthread_start + 148
          # 18  libsystem_pthread.dylib             0x00007fff6f52db8b thread_start + 15
          # ./spec/system/tasks_spec.rb:14:in `block (4 levels) in <top (required)>'

     1.2) Failure/Error: Unable to infer file and line number from backtrace
          
          Selenium::WebDriver::Error::SessionNotCreatedError:
            session not created: This version of ChromeDriver only supports Chrome version 85
          
          
          
          # 0   chromedriver                        0x0000000106d5f1b9 chromedriver + 4911545
          # 1   chromedriver                        0x0000000106cfee03 chromedriver + 4517379
          # 2   chromedriver                        0x000000010696cdc6 chromedriver + 773574
          # 3   chromedriver                        0x00000001068c8452 chromedriver + 99410
          # 4   chromedriver                        0x00000001068c4d6f chromedriver + 85359
          # 5   chromedriver                        0x00000001068f3716 chromedriver + 276246
          # 6   chromedriver                        0x00000001068f0723 chromedriver + 263971
          # 7   chromedriver                        0x00000001068ca720 chromedriver + 108320
          # 8   chromedriver                        0x00000001068cb693 chromedriver + 112275
          # 9   chromedriver                        0x0000000106d27f72 chromedriver + 4685682
          # 10  chromedriver                        0x0000000106d35b3a chromedriver + 4741946
          # 11  chromedriver                        0x0000000106d35801 chromedriver + 4741121
          # 12  chromedriver                        0x0000000106d0b25e chromedriver + 4567646
          # 13  chromedriver                        0x0000000106d36061 chromedriver + 4743265
          # 14  chromedriver                        0x0000000106d1cd0a chromedriver + 4640010
          # 15  chromedriver                        0x0000000106d4f0ba chromedriver + 4845754
          # 16  chromedriver                        0x0000000106d65387 chromedriver + 4936583
          # 17  libsystem_pthread.dylib             0x00007fff6f532109 _pthread_start + 148
          # 18  libsystem_pthread.dylib             0x00007fff6f52db8b thread_start + 15

Finished in 1.55 seconds (files took 1.47 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/system/tasks_spec.rb:20 # タスク管理機能 一覧表示機能 ユーザーAがログインしているとき ユーザーが作成したタスクが表示される
```

chrome内のメニューよりバージョンを確認し、最新バージョンへ更新することで解決