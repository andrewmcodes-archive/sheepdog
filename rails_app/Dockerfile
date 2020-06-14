ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION
LABEL MAINTAINER=dave@k-innovations.net

ARG NODE_MAJOR
ARG PG_MAJOR
ARG BUNDLE_VERSION
RUN apt-get update
RUN apt-get install -y build-essential

# Add PostgreSQL to sources list
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -   && echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get -y update
RUN apt-get -y install nodejs
RUN apt-get -y install yarn
RUN yarn config set "strict-ssl" false

RUN bundle config --global frozen 1

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v $BUNDLE_VERSION
RUN bundle install -j $(nproc)

RUN mkdir -p /app
WORKDIR /app
