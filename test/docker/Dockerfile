FROM ruby:3.3.14-slim-bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends make ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ADD docker/Gemfile /usr/src/app/
ADD docker/Gemfile.lock /usr/src/app/

WORKDIR /usr/src/app/

RUN gem install bundler && bundle install

ADD . /usr/src/app/

CMD bundle exec rspec
