# フラッシュメッセージ

```
redirect_to tasks_url, notice: "タスク「#{task.name}」を登録しました。"
```
上記は以下と同じである
```
flash[:notice] = "タスク「#{task.name}」を登録しました。"
redirect_to tasks_url
```

```
flash.notice = "タスク「#{task.name}」を登録しました。"
```