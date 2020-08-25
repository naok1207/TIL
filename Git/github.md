# githubを利用した開発手順

**プルリクエスト**
自分の変更したコードをリポジトリに取り込んでもらえるよう依頼する機能

**プルリクエストの手順**
1. masterブランチを最新に更新
2. ブランチを作成
3. ファイルを変更
4. 変更をコミット
5. Githubへプッシュ
6. プルリクエストを送る
7. コードレビュー
8. プルリクエストをマージ
9. ブランチを削除

**github Flow**
Github社のワークフロー
1. masterブランチからブランチを作成
2. ファイルを変更しコミット
3. 同名のブランチをGithubへプッシュ
4. プルリクエストを送る
5. コードレビューし、masterブランチにマージ
6. masterブランチをデプロイ

**Github Flow を実施する上でのポイント**
- masterブランチは常にデプロイできる状態を保つ
- 新開発はmasterブランチから新しいブランチを作成してスタート
- 定期的にPushする
- masterにマージするためにプルリクエストを使う
- 必ずレビューを受ける
- masterブランチにマージしたらすぐにデプロイする
← テストとデプロイ作業は自動化