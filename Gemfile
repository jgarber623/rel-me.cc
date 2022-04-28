# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.1.2'

gem 'puma'
gem 'rack'
gem 'rake'
gem 'roda', github: 'jeremyevans/roda', ref: 'df6dff1'
gem 'roda-sprockets'
gem 'sassc'
gem 'tilt'

group :development do
  gem 'pry-byebug'
  gem 'rerun'
end

group :test do
  gem 'bundler-audit', require: false
  gem 'code-scanning-rubocop', require: false
  gem 'rack-test'
  gem 'rspec'
  gem 'rspec-github', require: false
  gem 'rspec-its'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov', require: false
  gem 'simplecov-console', require: false
  gem 'webmock', require: false
end
