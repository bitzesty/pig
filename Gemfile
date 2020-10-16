source 'https://rubygems.org'

# Declare your gem's dependencies in pig.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

group :test do
  gem 'therubyracer'
  gem 'simplecov', :require => false
end

group :development, :test do
  gem 'guard'
  gem "guard-rspec", require: false
  gem "guard-cucumber", require: false
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'shoulda-matchers', require: false
  gem 'pry'
  gem 'pry-byebug'
  gem 'cucumber-rails', :require => false
  gem 'capybara-email'
  gem 'database_cleaner'
  gem "poltergeist"
  gem "launchy"
end
