source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'

ruby '2.2.3'

gem 'puma' # We need puma for the Heroku deploys to succeed

# Use postgresql as the database for Active Record
gem 'pg'
gem 'friendly_id', '~> 5.1.0'
gem 'net-ssh'
gem 'net-sftp'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'rails_12factor', group: :production

group :development, :test do
  gem 'rack-test'
  gem 'factory_girl_rails'
  gem 'rspec-rails', '~> 3.0'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'simplecov'
  gem 'faker'
  gem 'timecop'
  gem 'rails-erd'  # to auto-generate ERD and better understand the data structure
  gem 'teaspoon-jasmine'
  gem 'launchy'
end

group :development do
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'pivotal_git_scripts'
  gem 'rack-mini-profiler'
  gem 'spring'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'squasher'
end

# Auth
gem 'devise'

# Better seeds
gem 'seedbank'

# For more interesting random seed data
gem 'probability'
gem 'rubystats'

# Output PDFs
gem 'pdfkit'

# S3
gem 'aws-sdk-core', '~> 2'

gem 'thor'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use debugger
# gem 'debugger', group: [:development, :test]
