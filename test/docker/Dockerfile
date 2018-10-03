FROM ruby:2

ENV DOCKER_VERSION 1.13.1-0~debian-jessie

RUN apt-get update && \
    apt-get install -y make apt-transport-https ca-certificates && \
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 \
      --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    echo "deb https://apt.dockerproject.org/repo debian-jessie main" \
      > /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y docker-engine=$DOCKER_VERSION

ADD docker/Gemfile /usr/src/app/
ADD docker/Gemfile.lock /usr/src/app/

WORKDIR /usr/src/app/

RUN gem install bundler && bundle

ADD . /usr/src/app/

CMD bundle exec rspec
