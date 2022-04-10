#!/bin/bash

# 元のディレクトリを記録
CURRENT_DIR=$(pwd)

## backend のクリーン

# static ディレクトリ内をクリーン
SCRIPT_DIR=$(cd $(dirname $0); pwd)
rm -rf ${SCRIPT_DIR}/backend/src/main/resources/static/*

# mvn clean を実行
cd ${SCRIPT_DIR}/backend
./mvnw clean

# 元のディレクトリに戻る
cd ${CURRENT_DIR}

