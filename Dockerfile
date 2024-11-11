FROM alpine:latest as downloader
ARG VERSION=0.22.22
ARG ARCH=linux_amd64
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v${VERSION}/pocketbase_${VERSION}_${ARCH}.zip \
	&& unzip pocketbase_${VERSION}_${ARCH}.zip -d /tmp/ \
	&& chmod +x /tmp/pocketbase


FROM alpine:latest as base
WORKDIR /webapp
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
COPY --from=downloader /tmp/pocketbase /webapp/pocketbase
EXPOSE 8090
CMD ["./pocketbase", "serve", "--http=0.0.0.0:8090"]


# prefer over oven/bun because the former has compatiblity issues
FROM squishyu/bun-alpine:latest as frontend
WORKDIR /webapp
COPY ./package.json ./bun.lockb ./
RUN bun i
COPY ./ ./
RUN bun run build

FROM base as prod
COPY ./src-pb/pb_hooks /webapp/pb_hooks
COPY ./src-pb/pb_migrations /webapp/pb_migrations
COPY --from=frontend /webapp/build /webapp/pb_public
