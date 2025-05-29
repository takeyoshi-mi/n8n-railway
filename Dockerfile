FROM n8nio/n8n:latest

# 環境変数を設定
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=$PORT

# ポートを公開
EXPOSE $PORT

# n8nを起動
CMD ["n8n", "start"]
