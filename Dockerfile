FROM oven/bun:latest AS builder

WORKDIR /app

COPY package.json .
COPY bun.lock .
COPY . .
RUN bun i

RUN bun run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY ./.nginx/frontend.conf /etc/nginx/nginx.conf

EXPOSE 81
CMD ["nginx", "-g", "daemon off;"]