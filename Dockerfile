FROM ruby:2.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# see update.sh for why all "apt-get install"s have to stay as one long line
RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*

# see http://guides.rubyonrails.org/command_line.html#rails-dbconsole
RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

# bundle install first
RUN mkdir /mnt/somerville-teacher-tool
COPY Gemfile /mnt/somerville-teacher-tool/Gemfile
COPY Gemfile.lock /mnt/somerville-teacher-tool/Gemfile.lock
VOLUME /mnt/somerville-teacher-tool
WORKDIR /mnt/somerville-teacher-tool
RUN bundle install

COPY . /mnt/somerville-teacher-tool

EXPOSE 3000