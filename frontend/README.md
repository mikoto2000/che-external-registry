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
npm build
npm package
npm start
```

`http://localhost:8000` へ接続し、 `dist` -> `index.html` と選択する。


## デプロイ

1. `npm build` で `./dist/index.html` を生成する
2. `./src` から `./dist` へ、必要なファイルをコピー
   ```sh
   cp ./src/index.html ./dist/index.html
   cp ./src/stacks.json ./dist/stacks.json
   cp -r ./src/devfiles ./src/plugins ./dist
   ```
2. `gh-pages` ブランチのルートディレクトリに、 `./dist` ディレクトリ内のファイルをコピーする

