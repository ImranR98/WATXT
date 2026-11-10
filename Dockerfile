# W@TXT: one Node process over a conversation directory.
FROM node:latest@sha256:438603bbb5cda404b9416f0b5c8026f61501ab911760d861ec28c36b5d675725

WORKDIR /app

# Python's zipfile handles WhatsApp's FAT-origin unicode names; unzip validates.
RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 unzip ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json ./
COPY kit ./kit
RUN npm ci --no-audit --no-fund

COPY . .
RUN npm run build:ui \
    && npm prune --omit=dev \
    && chown -R node:node /app

ENV NODE_ENV=production
ENV HOME=/home/node
EXPOSE 8787

USER node
CMD ["node", "server.mjs"]
