FROM alpine

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="20221211"
LABEL description "che-external-registry"

RUN apk update \
    && apk add openjdk17-jre

COPY ./backend/target/che-external-registry-0.0.1-SNAPSHOT.jar /

# CDS ファイル作成
RUN timeout -s INT 5 java -XX:ArchiveClassesAtExit=cds.jsa -jar "/che-external-registry-0.0.1-SNAPSHOT.jar"; true

# 最適化コンパイラを OFF
ENV JAVA_TOOL_OPTIONS "-XX:+TieredCompilation -XX:TieredStopAtLevel=1"

# CDS を有効にして実行
CMD ["java", "-XX:SharedArchiveFile=cds.jsa", "-jar", "/che-external-registry-0.0.1-SNAPSHOT.jar"]

