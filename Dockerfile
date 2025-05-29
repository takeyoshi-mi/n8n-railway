FROM docker.n8n.io/n8nio/n8n:latest

# 環境変数設定
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=$PORT
ENV N8N_PROTOCOL=http
ENV NODE_ENV=production

# ポート公開
EXPOSE $PORT

# 権限設定
USER node

# 起動コマンド
ENTRYPOINT ["n8n"]
