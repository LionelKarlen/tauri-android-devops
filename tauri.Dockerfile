FROM ghcr.io/lionelkarlen/tauri-android-docker:main as base
WORKDIR /androidapp
COPY ./package.json ./bun.lockb ./
RUN bun i
COPY ./ ./
RUN bun tauri android build
