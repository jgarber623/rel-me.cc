ruby '2.7.2'

source 'https://rubygems.org'

gem 'addressable', '~> 2.7'
gem 'http', '~> 4.4'
gem 'micromicro', '~> 1.0'
gem 'rack', '~> 2.2'
gem 'rack-host-redirect', '~> 1.3'
gem 'rack-ssl-enforcer', '~> 0.2.9'
gem 'sinatra', '~> 2.0'
gem 'sinatra-contrib', '~> 2.0'
gem 'sinatra-param', github: 'jgarber623/sinatra-param', tag: 'v3.4.0'

group :development, :test do
  gem 'bundler-audit', '~> 0.7.0.1'
  gem 'rack-test', '~> 1.1'
  gem 'rake', '~> 13.0'
  gem 'reek', '~> 6.0', require: false
  gem 'rspec', '~> 3.10'
  gem 'rubocop', '~> 1.10', require: false
  gem 'rubocop-performance', '~> 1.9', require: false
  gem 'rubocop-rake', '~> 0.5.1', require: false
  gem 'rubocop-rspec', '~> 2.2', require: false
  gem 'webmock', '~> 3.11', require: false
end

group :development do
  gem 'shotgun', '~> 0.9.2'
end

group :test do
  gem 'simplecov', '~> 0.21.2', require: false
  gem 'simplecov-console', '~> 0.9.1', require: false
end
