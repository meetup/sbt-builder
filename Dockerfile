##FROM ghcr.io/meetup/openjdk:8u282-jdk
FROM ghcr.io/meetup/openjdk:8u312-jdk

RUN apt-get update && apt-get install -y --no-install-recommends \
        make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Docker

RUN set -x \
     && wget -O get-docker.sh https://get.docker.com \
     && sh ./get-docker.sh \
     && rm get-docker.sh

# Install SBT
ENV SBT_VERSION 1.5.1

RUN cd /usr/local && \
    wget https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz && \
    tar -xf sbt-${SBT_VERSION}.tgz && \
    rm sbt-${SBT_VERSION}.tgz && \
    ln -s /usr/local/sbt/bin/sbt /usr/bin/sbt

WORKDIR /data

ENV LANG C.UTF-8

CMD ["make", "package-sbt"]
