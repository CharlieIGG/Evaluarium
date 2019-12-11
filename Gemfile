source "https://rubygems.org"

ruby "2.6.3"

gem "rails", "~> 6.0.0"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.12"
gem "sass-rails", "~> 5"
gem 'jquery-rails'
gem "bootsnap", ">= 1.4.2", require: false
gem "rack-canonical-host"
gem "webpacker", "~> 4.0"
gem "redis", '~> 4.0'
gem 'bootstrap', '~> 4.3.1'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# For memory profiling
gem "rack-mini-profiler", require: false

# CSS frameworks
gem "normalize-rails"
gem "autoprefixer-rails"

# Active Jobs
gem 'sidekiq', '~> 5.2', '>= 5.2.5'

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "spring-commands-rspec"
  gem "bundler-audit", ">= 0.5.0", require: false
  gem "annotate"
  gem "rack-timeout", require:"rack/timeout/base"
  gem "rails-erd"
end

# Test gems
group :test do
  gem 'guard-rspec'
  gem "shoulda-matchers"
  # Generate test coverage reports:
  gem "simplecov", "~> 0.16.1", require: false
  # Format test coverage reports for console output:
  gem "simplecov-console", "~> 0.4.2", require: false
  gem "simplecov-json", require: false
  gem "simplecov-reporter", require: false
end

group :development, :test do
  gem "bullet"
  gem "pry"
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "rspec-rails", "~> 3.8"
  gem "ffaker"

  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem 'webdrivers', '~> 4.0'
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "devise"
gem "rolify"
gem "devise_invitable", "~> 1.7.0"
gem "kaminari"
gem "mini_magick"
gem "aws-sdk-s3", "~> 1.9", require: false
