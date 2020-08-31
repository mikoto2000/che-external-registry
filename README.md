# che-external-registry

[https://mikoto2000.github.io/che-external-registry](https://mikoto2000.github.io/che-external-registry) のソースリポジトリ。

Eclipse Che が提供していないスタックを提供することを目的としたサイト。

## サイトの使い方

1. `Che URL` に利用したい Eclipse Che サービスの URL を入力
2. スタック名が記載されたリンクをクリック
    - リンクをクリックすると、 `Che URL` に入力したサービスでスタックを立ち上げる
    - `Filter` に文字列を入力することで、スタックの絞り込み検索が可能


## elm reactor での動作確認:

```sh
elm reactor
```

`http://localhost:8008` へ接続し、 `src` -> `Main.elm` と選択する。


## デプロイ

1. `elm make src/Main.elm` で `./index.html` を生成する
2. `gh-pages` ブランチのルートディレクトリに、 `./index.html` と `./src/stacks.json` をコピーし、コミットする

