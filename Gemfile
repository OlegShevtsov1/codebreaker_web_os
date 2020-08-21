# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

group :development do
  gem 'codebreaker_os', git: 'https://github.com/OlegShevtsov1/codebreaker_os', branch: 'develop'
  gem 'faker', '~> 2.13'
  gem 'haml', '~> 5.1.2'
  gem 'i18n'
  gem 'overcommit', '~> 0.53.0', require: false
  gem 'pry', '~> 0.12.2'
  gem 'rack', '~> 1.6', '>= 1.6.4'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
  gem 'solargraph'
end

group :test do
  gem 'rack-test', '~> 1.1'
  gem 'rspec', '~> 3.7'
  gem 'rspec_junit_formatter', '~> 0.4.1'
  gem 'simplecov', require: false
  gem 'temple', '~> 0.8.2'
end
