FROM node:20-alpine AS builder
ARG N8N_VERSION=1.103.2

# ビルド依存関係のインストール
RUN apk add --update --no-cache \
    graphicsmagick \
    tzdata \
    git \
    python3 \
    build-base \
    ca-certificates

# n8nのグローバルインストール
RUN npm_config_user=root npm install --location=global n8n@${N8N_VERSION}

# 本番用イメージ
FROM node:20-alpine

# 実行時に必要なパッケージのみインストール
RUN apk add --update --no-cache \
    graphicsmagick \
    tzdata \
    ca-certificates \
    su-exec

# n8n関連ファイルをコピー
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder /usr/local/bin /usr/local/bin

# 必要なディレクトリの作成と権限設定
RUN mkdir -p /home/node/.n8n && \
    mkdir -p /data && \
    chown -R node:node /home/node/.n8n && \
    chown -R node:node /data

# 作業ディレクトリの設定
WORKDIR /data

# 環境変数の設定
ENV N8N_USER_FOLDER=/home/node/.n8n
ENV NODE_ENV=production

# ポート公開
EXPOSE 5678

# ユーザーをnodeに切り替え
USER node

# n8nの起動コマンド
CMD ["n8n", "start"]
