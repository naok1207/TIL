# Webアプリケーションの基本
## 01. Webアプリケーションの３層構造
**Webアプリケーション**
ネットワークを介してWebブラウザ上で動作するアプリケーション

**３層構造（３層アーキテクチャ）**
Webアプリケーションは基本的に３層構造（３層アーキテクチャ）と呼ばれる階層的な構造になっている。

|層|処理内容|ソフトウェア|
|---|---|---|
|プレゼンテーション層|ユーザーインターフェース|Webブラウザ、Webサーバー|
|アプリケーション層|業務処理|アプリケーションサーバー（APサーバー）|
|データ層|データ処理や保管|データベースサーバー|

クライアントサイト・スクリプトはプレゼンテーション層
サーバーサイド・スクリプトはアプリケーション層で動作する。

**負荷分散**
複雑な処理を実装するとアプリケーション層やデータ層の負荷が高くなり、アクセス数が多くなるとプレゼンテーション層の負荷が高くなるため、システムの規模が大きくなると一般的に格層ごとにサーバー機器を分けた構成をとる。

階層が分かれていることにより改修が容易になる。

## 02. MVCモデル

**MVCモデル**
Model View Controller 各要素がお互いに連携してアプリケーションの処理を行う構造
Model : アプリケーションの扱うデータと業務処理
View : ユーザーへの出力処理
Controller : 必要な処理をModelやViewに伝える役割

**３層アーキテクチャとの違い**
3層アーキテクチャは階層構造であり、最上層のプレゼンテーション層と最下層のデータ層が直接やり取り捨ことはない。
WebアプリケーションにおいてはMVCモデルの表す範囲は３層アーキテクチャのアプリケーション層とデータ層であり、プレゼンテーション層はMVCモデルとユーザー間の仲介を行う部分

**MVCモデルの利点**
開発や改修の分業が容易になること
仕様変更が別要素へ影響を及ぼさないため、各要素ごとに個別に開発を行うことが可能。

## 03. フレームワーク

**フレームワーク**
一般的な処理の流れを「ひな形」として準備しておき、Webアプリケーションごとの独自の内容を開発者が埋めることにより開発できるようにしたもの。

Java : Java EE, Struts, Spriing Boot
PHP : CakePHP
Ruby : Ruby on Rails

## 04. Webサーバー

**Webサーバー**
Webアプリケーションにおいて、Webクライアントに対する窓口の役割を果たすプログラム
Webクライアントからのリクエストを受け取って静的コンテンツを配信したり、動的処理の必要なものがあればサーバーサイド・プログラムと連携し、処理の結果として作成されたHTMLファイルをWebブラウザへ転送したりする。

Webサーバーの機器台数を多くし、１台あたりの負担を少なくするとともに、１台が故障しても別のサーバーだけでサービスを続けられるようにする「__冗長化__」とういう構成をとることが一般的

## 05. Webクライアント

**Webクライアント**
Webシステムを利用するためのプログラムのこと
基本的な機能は、Webサーバーへリクエストを送り、Webサーバーからのレスポンスを受け取ってそれを解釈すること。
ユーザーとWebサーバーの橋渡し。

**Webブラウザ**
Webアプリケーションを利用するためのWebクライアントとして最も利用されているもの。
元々はハイパーテキストを表示するためのプログラムだったが、クライアントサイド・スクリプトの実行やCookieの管理など多くの機能を持つようになったことで、現在では多くのWebアプリケーションがWebブラウザで実行できるようになっている。

**クライアントプログラム**
Webブラウザとは異なり、対応するWebアプリケーションに特化した機能を持つプログラム
一般的に専用クライアント、専用ブラウザと呼ばれる。パソコン用であればデスクトップアプリ、スマートフォン用であればスマホアプリと呼ばれることがある。

## 06. アプリケーションサーバー

**アプリケーションサーバー（APサーバー）**
Webアプリケーションの中核となるプログラム
Webサーバーから転送されてきたユーザーからのデータを受け取り、サーバーサイド・プログラムを実行することで、そのデータを加工したり、データベースのデータを検索加工した後、Webサーバーに応答を返す。

３層アーキテクチャにおけるアプリケーション層に位置し、プレゼンテーション層とデータ層の両方とのやり取りも行うことから、３層アーキテクチャにおいては最も多機能なサーバーであると言える。

サーバーサイド・スクリプトを動作させるためのメモリ容量や、CPU性能が重視される。

**トランザクション**
セッション中で行われる一連の作業の最小単位のこと。

## 07. データベース管理システム

**データベース管理システム(DBMS : DataBase Management System)**
主に、アプリケーションサーバーからデータの検索や更新命令を受け、それにしたがってデータの管理を行う。
DBMSを搭載したサーバー機器を一般にデータベースサーバーと呼ぶ。

メモリやCPUといったサーバー機器の性能、ハードディスクの読み取り速度が重要になる。

Webアプリケーションにとって重要なデータを扱うため、データ消失の対策も重要になる

データベースにとって保持するデータの保全は非常に重要。そのため、DBサーバーも基本的に冗長化構成をとる。

**データベースの冗長化方法**
|名称|内容|
|---|---|
|ミラーリング|データの更新命令を受けたDBMSが複数のデータベースに対して同時に同じ更新を行うことでデータベースを冗長化する方法|
|レプリケーション|データの更新命令を受けたDBMSが更新の内容を別のDBMSに連携し、連携を受けたDBMSが同じ内容の更新を自身の管理するデータベースに実施する。|
|シェアードディスク|データベースを共用の機器（データストレージ）に持ち、複数のDBサーバー（DBMS）からそれを更新する。DBサーバーのみの冗長化となるため、データベースを格納する機器には耐障害性の強い機器を採用する必要がある。|

## 08. キャッシュサーバー

**キャッシュ**
リクエストに対するレスポンスの記憶

**コンテンツキャッシュ**
文書や画像といったコンテンツのキャッシュ

**クエリキャッシュ**
DBMSのデータ検索要求（クエリ）の結果

**CDN(Contents Delivery Network)**
世界各地に分散して設置「されたキャッシュサーバーの集合体
予め画像やどうがなどの大容量のコンテンツのキャッシュをWebサーバーから取得しておき、CDN全体で１台のコンテンツキャッシュサーバーのように動作する。CDN内部ではリクエストに対し、アクセス元からネットワーク的に最も近いサーバーが対応することで、より早いレスポンスが返せるようになっている。

## 09. Ajax

**同期通信**
クライアントとサーバーが交互に処理を行い、同調して通信を行うこと。
サーバーが処理を行っている間、クライアントは待つことしかできず、HTMLファイルを受け取ってから表示処理を行うため、全体としてページの更新に時間がかかってしまう。また、送信するデータも多くなりがちで、サーバーに負担がかかる。

**Ajax(Asynchronous JavaScript + XML)**
同期通信の欠点を補うために登場した。
Webブラウザ上でクライアントサイド・スクリプトとして動くJavaScriptが直接Webサーバーと通信を行い、取得したデータを用いて、表示するHTMLを更新する。
HTMLそのものをやり取りするのではなく、更新に必要なデータのみをやり取りするため、送信するデータの量は同期通信の時よりも少なくなり、サーバーへの負担が抑えられる。

ajaxではWebブラウザの代わりにWebブラウザ上で動くJavaScriptが通信を行うため、JavaScriptの機能を使った非同期通信が可能となる。

## 10. Webプログラミング

**Webプログラミングの特徴**
対象となるプログラミングが __サーバーサイド・スクリプト__ と __クライアントサイド・スクリプト__ の２種類

**サーバーサイド**
サーバーサイド・スクリプトは多くのクライアントのリクエストを素早く処理することが求められるため、効率的な手順で処理を行うことや、サーバーのメモリを無駄にしないことが求められる。
他にも、幅広い知識を必要とする。

## 11. WebAPI

**Web API(Application Program Interface)**
クライアントがデータを送信して、サーバーからデータを返送してもらうという動作を利用して、Webを通じてユーザーではなくプログラムが直接サービスを利用するための窓口となる。
JsonやXMLのようなデータが返される。

**XML-RPC**
XMLを送信することで処理の実行を要求するプロトコルで、受信するデータの形式にもXMLが使われる。

**SOAP**
XML-RPCの機能を拡張したもの。
高機能であり、2000年初頭までは広く利用されていたが、使用が複雑なこともあり最近は利用が減ってきている。

**REST**
シンプルな設計で、かつデータの形式がXMLに限定されずJSONのような軽量なデータも利用できることから、SOAPに代わり主流となっている。

## 12. マッシュアップ

**マッシュアップ**
複数のWebサービスを組み合わせて新たなWebサービスを生み出すこと

## 13. CGI

**CGI**
Webサーバーがクライアントからの要求に応じてサーバーサイド・スクリプトを起動するための仕組み

**データの渡し方**
|名称|方法|
|---|---|
|コマンドライン渡し|URLの末尾に「？」をつけ、その後にデータを「＋」で区切って並べる|
|パス渡し|URLの後に「/」で区切ってデータを並べる|
|HTTP渡し|URLの末尾にデータを「？」の後ろに 「&」区切りで並べる|

## 14. サーバー間の連携

**AJP** **WebSocket**
HTTPの他のプロトコル

**ODBC(Open Database Connectivity)**
DBMSではそれぞれ独自のプロトコルが採用されており、格APサーバーがそのすべてに対応することが難しいため、APサーバーとDBMS間で通信を行うために開発されたAPI

## column クライアントプログラムとWebサーバー