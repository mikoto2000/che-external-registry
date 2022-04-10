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

# install Heroku CLI
RUN curl https://cli-assets.heroku.com/install-ubuntu.sh | sh

# install docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg \
    | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bullseye stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update \
    && apt-get -y install \
        docker-ce \
        docker-ce-cli \
        containerd.io \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ["bash"]

