FROM alpine

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="20220410"
LABEL description "che-external-registry"

RUN apk update \
    && apk add openjdk17-jre

COPY ./backend/target/che-external-registry-0.0.1-SNAPSHOT.jar /

CMD ["java", "-Dserver.port=${PORT}", "-jar", "/che-external-registry-0.0.1-SNAPSHOT.jar"]

