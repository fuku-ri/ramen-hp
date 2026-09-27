# 麺処 朱 — Cloudflare Workers 店舗サイト

実店舗向けの公開サイトとスタッフ管理画面です。管理画面の変更はD1へ保存され、すべてのお客様へ反映されます。メニュー写真はR2へ保存します。

## 主な機能

- お客様向けメニュー、売り切れ表示、店舗情報
- 空席あり／少し待ち／満席／営業時間外の即時切替
- メニューの追加、編集、削除、写真アップロード
- 店名、住所、営業時間、定休日、席数、GoogleマップURLの編集
- 初回管理者登録、パスワードログイン、HttpOnlyセッション
- ログイン連続失敗時の15分ロック
- スマートフォン対応

## 使用するCloudflareサービス

- Workers：WebサイトとAPI
- D1：店舗情報、メニュー、管理者、セッション
- R2：アップロード画像

## 初回デプロイ手順

### 1. 準備

```bash
npm install
npx wrangler login
```

### 2. D1データベースを作成

```bash
npx wrangler d1 create ramen-shop-db
```

表示された `database_id` を `wrangler.jsonc` の `D1_DATABASE_ID` と置き換えます。

### 3. R2バケットを作成

```bash
npx wrangler r2 bucket create ramen-shop-images
```

### 4. データベースを初期化

```bash
npm run db:remote
```

### 5. 初回登録用の秘密文字列を登録

推測できない長いランダム文字列を用意し、次を実行します。

```bash
npx wrangler secret put SETUP_TOKEN
```

入力欄へ秘密文字列を貼り付けます。この値はGitHubへ保存しないでください。

### 6. デプロイ

```bash
npm run deploy
```

表示されたURLの `/admin.html` を開き、セットアップトークン、任意のスタッフユーザー名、12文字以上のパスワードを入力します。

## GitHub連携で自動デプロイする場合

Cloudflare Workers BuildsでGitHubリポジトリを接続し、デプロイコマンドを `npx wrangler deploy` にします。D1、R2、Secretは先に上記手順で作成してください。

## ローカル確認

`.dev.vars.example` を `.dev.vars` としてコピーし、ローカル専用の `SETUP_TOKEN` を設定します。

```bash
npm run db:local
npm run dev
```

## 変更する主なファイル

- `public/index.html`：公開ページ
- `public/admin.html`：管理画面
- `public/styles.css`：デザイン
- `src/worker.js`：API、認証、D1・R2処理
- `migrations/0001_initial.sql`：データベース構造と初期メニュー
- `wrangler.jsonc`：Cloudflare設定

## セキュリティ上の注意

- `.dev.vars` やセットアップトークンをGitHubへpushしないでください。
- 管理者パスワードには店舗名や電話番号など推測しやすい文字列を使用しないでください。
- 管理画面URLは公開されても、サーバー側認証なしではデータを変更できません。
