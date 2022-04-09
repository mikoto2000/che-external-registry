FROM node:17

LABEL maintainer "mikoto2000 <mikoto2000@gmail.com>"
LABEL version="20220409"
LABEL description "NodeJS: 17, OpenJDK: 17, Maven, Heroku CLI"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get -y install \
        curl \
        git \
        gnupg2 \
        openjdk-17-jdk-headless \
        maven \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://cli-assets.heroku.com/install-ubuntu.sh | sh

CMD ["bash"]

