FROM ruby:3.2.6

ARG SPINA_VERSION
ARG RAILS_VERSION
ARG PORT
ENV PORT=${PORT}
# Install dependencies
RUN --mount=type=cache,target=/var/lib/apt \
    apt-get update && \
    apt-get install -y build-essential libpq-dev nodejs

RUN --mount=type=cache,target=/usr/local/bundle \
    gem update --system && \
    gem install bundler && \
    gem install rails -v "${RAILS_VERSION}" && \
    gem install spina -v "${SPINA_VERSION}"

WORKDIR /app

COPY MannyCRM/Gemfile /app/Gemfile
COPY MannyCRM/Gemfile.lock /app/Gemfile.lock

RUN bundle install

COPY MannyCRM /app

EXPOSE ${PORT}

CMD ["rails", "server", "-b", "0.0.0.0", "-p", ${PORT}]
