FROM amazoncorretto:8u232

RUN apt-get update && apt-get install -y --no-install-recommends \
        make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Docker
ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.13.1
ENV DOCKER_SHA256 97892375e756fd29a304bd8cd9ffb256c2e7c8fd759e12a55a6336e15100ad75

RUN set -x \
    && wget -O docker.tgz "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" \
    && echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
    && tar -xzvf docker.tgz \
    && mv docker/* /usr/local/bin/ \
    && rmdir docker \
    && rm docker.tgz \
    && docker -v

# Install SBT
ENV SBT_VERSION 0.13.17

RUN cd /usr/local && \
    wget https://piccolo.link/sbt-${SBT_VERSION}.tgz && \
    tar -xf sbt-${SBT_VERSION}.tgz && \
    rm sbt-${SBT_VERSION}.tgz && \
    ln -s /usr/local/sbt/bin/sbt /usr/bin/sbt

WORKDIR /data

ENV LANG C.UTF-8

CMD ["make", "package-sbt"]
