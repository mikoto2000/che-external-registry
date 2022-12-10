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


## backend のビルド
cd ${SCRIPT_DIR}/backend
#./mvnw spring-boot:run
./mvnw clean package


## Docker イメージのビルド
cd ${SCRIPT_DIR}
docker build -t mikoto2000/che-external-registry -f ./dockerfile/Dockerfile .
# docker push mikoto2000/che-external-registry:latest


# 元のディレクトリに戻る
cd ${CURRENT_DIR}


