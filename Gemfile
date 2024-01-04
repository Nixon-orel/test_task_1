source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"

gem "rails", "~> 7.0.8"
gem 'pg'
gem 'activerecord-import'
gem 'faraday_middleware'
gem 'faraday'
gem 'rswag-api'
gem 'rswag-ui'
gem 'pg_search'
gem 'grape'
gem 'delayed_job_active_record'
gem 'rufus-scheduler'
gem 'puma'
gem 'figaro'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]
gem 'bootsnap', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails', '6.2.0'
  gem 'faker'
  gem 'database_cleaner-active_record'
  gem 'pry-rails'
  gem 'rswag-specs'
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end
