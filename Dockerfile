FROM node:20-alpine AS builder
ARG N8N_VERSION=1.103.2

RUN apk add --no-cache python3 make g++ git
RUN npm install -g n8n@${N8N_VERSION} --omit=dev

FROM node:20-alpine
RUN apk add --no-cache graphicsmagick tzdata dumb-init

COPY --from=builder /usr/local/lib/node_modules/n8n /usr/local/lib/node_modules/n8n
COPY --from=builder /usr/local/bin/n8n /usr/local/bin/n8n

# メモリ効率を最大化
ENV NODE_OPTIONS="--max-old-space-size=6144 --optimize-for-size"
ENV UV_THREADPOOL_SIZE="16"

WORKDIR /data
EXPOSE 5678

ENTRYPOINT ["dumb-init", "--"]
CMD ["n8n", "start"]
