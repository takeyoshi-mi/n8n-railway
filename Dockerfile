FROM node:20-alpine AS builder
ARG N8N_VERSION=1.103.2
RUN apk add --update graphicsmagick tzdata git python3 build-base
RUN npm_config_user=root npm install --location=global n8n@${N8N_VERSION} --production

FROM node:20-alpine
RUN apk add --update graphicsmagick tzdata
COPY --from=builder /usr/local/lib/node_modules/n8n /usr/local/lib/node_modules/n8n
RUN ln -s /usr/local/lib/node_modules/n8n/bin/n8n /usr/local/bin/n8n
