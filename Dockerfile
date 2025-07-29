FROM node:20-alpine

ARG N8N_VERSION=1.103.2

# 必要なパッケージの一括インストール
RUN apk add --no-cache graphicsmagick tzdata git python3 make g++

# n8n専用ユーザーの作成
RUN addgroup -g 1000 n8n && \
    adduser -u 1000 -G n8n -s /bin/sh -D n8n

# n8nのインストール（ビルド依存関係の適切な管理）
RUN npm install --location=global --production n8n@${N8N_VERSION}

# データディレクトリの準備
WORKDIR /home/n8n
RUN chown -R n8n:n8n /home/n8n

# n8nユーザーに切り替え
USER n8n

# パフォーマンス最適化の環境変数
ENV NODE_ENV=production \
    N8N_LOG_LEVEL=warn \
    N8N_DIAGNOSTICS_ENABLED=false \
    EXECUTIONS_DATA_PRUNE=true \
    EXECUTIONS_DATA_MAX_AGE=168 \
    N8N_METRICS=false

EXPOSE 5678

# 直接的なポート指定による高速起動
CMD ["sh", "-c", "N8N_PORT=${PORT:-5678} n8n start"]
