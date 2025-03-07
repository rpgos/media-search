FROM ruby:3.0.7-slim-bullseye as base

RUN apt-get update -qq && apt-get install -y build-essential apt-utils libpq-dev nodejs

WORKDIR /docker/app

RUN gem install bundler

COPY Gemfile* ./

RUN bundle install

ADD . /docker/app

EXPOSE 3000

CMD [ "bundle","exec", "puma", "config.ru"]
