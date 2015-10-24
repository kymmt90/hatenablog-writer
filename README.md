# はてなブログライター

**はてなブログライター**は Ruby 製はてなブログ投稿ツールです。

## 概要

    $ vi foo.md
    タイトル 1

    ここが内容です。

    $ vi bar.md
    タイトル 2

    **Markdown** で書けます。

    $ hw foo.md bar.md   # はてなブログへ二つのエントリを投稿

## 準備

    $ gem install bundler
    $ bundle install

はてなの API を利用しているため、OAuth アクセストークンを取得する必要があります。（詳しくは[Ruby ではてな OAuth のアクセストークンを取得する - kymmt's note](http://kymmt90.hatenablog.com/entry/hatena_oauth)を参照）

以下の形式の `config.yml` という設定ファイルをツールのルートディレクトリに配置してください。

    consumer_key: <Hatena application consumer key>
    consumer_secret: <Hatena application consumer secret>
    access_token: <Hatena application access token>
    access_token_secret: <Hatena application access token secret>
    user_id: <Hatena user ID>
    blog_id: <Hatenablog ID>

## 使いかた

### エントリ投稿

以下のような形式のローカルのテキストファイルに書きます。
2 行目はツールが利用するので空けてください。

    $ cat foo.md
    ここがタイトルです
                       # 2 行目は空ける
    ここが内容です。
    Markdown で書けます。

エントリを投稿するときは。テキストファイルを入力として、以下のコマンドを実行します。入力するテキストファイルは複数個指定できます。

    $ hw foo.md

### エントリ更新

エントリを更新するときは、まずローカルのテキストファイルを編集します。次に、オプション `-u` または `--update` を指定してコマンドを実行します。このコマンドでは、はてなブログのエントリの更新日時は投稿した日時に更新されます。

    $ hw -u foo.md

オプション `-m`　または `--minor-update`　を指定してコマンドを実行すると、はてなブログのエントリの更新日時は変更せずに記事を更新します。

    $ hw -m foo.md

### カテゴリ付与

エントリ投稿／更新時にエントリにカテゴリを付与できます。カテゴリを付与するときは、オプション `-c` または `--category`　を指定してコマンドを実行します。複数カテゴリを指定するときは、`-c` または `--category` オプションを複数指定してください。

    $ hw -c "テスト" -c "プログラミング" foo.md        # エントリ投稿時のカテゴリ付与
    $ hw -c "テスト" -c "プログラミング" -m foo.md     # エントリ更新時のカテゴリ付与

あるエントリのカテゴリを削除するときはオプション引数なしで `-c` または `--category` を指定してください。

### エントリ削除

エントリを削除するときは、対応するローカルのテキストファイルを指定して以下のコマンドを実行します。

    $ hw -d foo.md

## ライセンス

MIT
