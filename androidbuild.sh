#!/bin/sh

docker build -t tauri_build -f tauri.Dockerfile .

docker create --name build_container tauri_build
#COPY /androidapp/src-tauri/gen/android/app/build/outputs/apk/universal/release/app-universal-release-unsigned.apk ./release.apk
docker cp build_container:/androidapp/src-tauri/gen/android/app/build/outputs/apk/universal/release/app-universal-release-unsigned.apk ./release.apk
#COPY /androidapp/src-tauri/gen/android/app/build/outputs/bundle/universalRelease/app-universal-release.aab ./release.aab
docker cp build_container:/androidapp/src-tauri/gen/android/app/build/outputs/bundle/universalRelease/app-universal-release.aab ./release.aab
docker rm -f build_container
