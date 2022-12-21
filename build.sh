#!/bin/bash

# 元のディレクトリを記録
CURRENT_DIR=$(pwd)

SCRIPT_DIR=$(cd $(dirname $0); pwd)

## frontend のビルド・デプロイ
cd ${SCRIPT_DIR}/frontend
#npm run dev
npm run build
rm -rf ../backend/src/main/resources/static/*
cp -r ./dist/* ../backend/src/main/resources/static


## backend Docker イメージのビルド
cd ${SCRIPT_DIR}/backend
#./mvnw spring-boot:run
./mvnw -Pnative clean spring-boot:build-image \
    -Dspring-boot.build-image.imageName=mikoto2000/che-external-registry:latest
# docker push mikoto2000/che-external-registry:latest


# 元のディレクトリに戻る
cd ${CURRENT_DIR}


