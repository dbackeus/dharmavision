source "https://rubygems.org"

gem "rails"

gem "coffee-rails"
gem "dotenv-rails"
gem "jquery-rails"
gem "mongoid"
gem "sass-rails"
gem "turbolinks"
gem "uglifier"

group :development do
  gem "guard", require: false
  gem "guard-rspec", require: false
  gem "guard-pow", require: false
  gem "terminal-notifier-guard", require: false
  gem "rb-fsevent", require: false
end

group :development, :test do
  gem "byebug"
  gem "web-console"
  gem "rspec-rails"
end

group :test do
  gem "database_cleaner"
  gem "mongoid-rspec"
  gem "factory_girl_rails"
end

group :production do
  gem "rails_12factor"
  gem "heroku-deflater"
end
