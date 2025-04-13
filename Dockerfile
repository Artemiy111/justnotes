FROM oven/bun:alpine AS builder

WORKDIR /app

COPY package.json bun.lock ./
RUN bun i --frozen-lockfile --production --no-cache
COPY . .

RUN bun run build

FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY ./.nginx/frontend.conf /etc/nginx/nginx.conf

EXPOSE 81
CMD ["nginx", "-g", "daemon off;"]