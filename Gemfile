source 'https://rubygems.org'

# Specify your gem's dependencies in hbird_notification.gemspec
gemspec

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem "factory_girl"
  gem "mocha"
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "simplecov", require: false
  gem 'shoulda-matchers', require: false
  gem "debugger"
  gem "therubyracer"
end

gem "locomotive_cms", path: '../../locomotive_engine', require: 'locomotive/engine'

group :assets do
  gem 'compass-rails',  '~> 1.1.7'
  gem 'sass-rails',     '~> 3.2.4'
  gem 'coffee-rails',   '~> 3.2.2'
  gem 'uglifier',       '~> 1.2.4'
end

group :locomotive_plugins do
  gem "hbird_notification", path: '.'
end
