FROM oven/bun:latest AS builder

WORKDIR /app

COPY package.json .
COPY bun.lock .
COPY . .
RUN bun i

RUN bun run build

FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 81
CMD ["nginx", "-g", "daemon off;"]