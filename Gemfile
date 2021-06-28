# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.7.0"

gem "bcrypt"
gem "bootsnap", ">= 1.4.4", require: false
gem "bootstrap-sass", "3.4.1"
gem "bootstrap-will_paginate", "1.0.0"
gem "cancancan"
gem "config"
gem "devise"
gem "factory_bot_rails"
gem "faker", "2.1.2"
gem "jbuilder", "~> 2.7"
gem "mysql2", "0.5.2"
gem "puma", "~> 5.0"
gem "rails", "~> 6.1.3", ">= 6.1.3.2"
gem "rails-controller-testing"
gem "rails-i18n"
gem "rspec-activemodel-mocks"
gem "sass-rails", ">= 6"
gem "simplecov"
gem "simplecov-rcov"
gem "sqlite3", "~> 1.4"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 5.0"
gem "will_paginate", "3.1.8"

group :test do
  gem "shoulda-matchers", "~> 4.0"
end

group :development, :test do
  gem "rspec-rails", "~> 4.0.1"
end

group :development, :test do
  gem "byebug", platforms: %i(mri mingw x64_mingw)
end

group :development, :test do
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false
end

group :development do
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
  gem "web-console", ">= 4.1.0"
end

group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby)
