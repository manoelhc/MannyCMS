FROM ruby:3.2.6 AS builder

ARG SPINA_VERSION
ARG RAILS_VERSION
ARG PORT
ENV PORT=${PORT}

# Install dependencies
RUN --mount=type=cache,target=/var/lib/apt \
    apt-get update && \
    apt-get install -y build-essential libpq-dev nodejs npm

RUN --mount=type=cache,target=/usr/local/bundle \
    gem update --system && \
    gem install bundler && \
    npm install --global yarn && \
    gem install rails -v "${RAILS_VERSION}" && \
    gem install spina -v "${SPINA_VERSION}"

WORKDIR /app

COPY ./MannyCMS .

RUN bundle install && \
        rails webpacker:install && \
        yarn install --check-files

EXPOSE 3030


CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3030"]
