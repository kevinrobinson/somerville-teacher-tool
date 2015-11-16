# This is based off https://github.com/docker-library/rails/blob/7926577517fb974f9de9ca1511162d6d5e000435/Dockerfile
FROM ruby:2.2

# From https://docs.docker.com/engine/articles/dockerfile_best-practices/
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    libpq-dev \
    nodejs \
    postgresql-client \
    wkhtmltopdf \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# copy just the Gemfile/Gemfile.lock first, so that with regular code changes
# this layer doesn't get invalidated and docker can use a cached image that 
# has already run bundle install
RUN mkdir /mnt/rails
COPY Gemfile /mnt/rails/Gemfile
COPY Gemfile.lock /mnt/rails/Gemfile.lock
WORKDIR /mnt/rails
RUN bundle install

COPY . /mnt/rails

EXPOSE 3000