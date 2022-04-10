#!/bin/bash

# 元のディレクトリを記録
CURRENT_DIR=$(pwd)

SCRIPT_DIR=$(cd $(dirname $0); pwd)

## frontend のビルド・デプロイ
cd ${SCRIPT_DIR}/frontend
npm run build
cp ./src/index.html ./dist/index.html
cp ./src/stacks.json ./src/main.css ./dist/
cp -r ./src/devfiles ./src/plugins ./dist
cp -r ./dist/* ../backend/src/main/resources/static


## backend のビルド
cd ${SCRIPT_DIR}/backend
#./mvnw spring-boot:run
./mvnw clean package


## Docker イメージのビルド
cd ${SCRIPT_DIR}
docker build --no-cache -t mikoto2000/che-external-registry -f ./dockerfile/Dockerfile .


## Heroku へデプロイ
docker tag mikoto2000/che-external-registry registry.heroku.com/che-external-registry/web
docker push registry.heroku.com/che-external-registry/web
heroku container:release web


# 元のディレクトリに戻る
cd ${CURRENT_DIR}


