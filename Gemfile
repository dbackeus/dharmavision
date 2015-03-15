source "https://rubygems.org"

gem "rails"

gem "bootstrap-sass"
gem "coffee-rails"
gem "devise"
gem "dotenv-rails"
gem "imdb"
gem "jquery-rails"
gem "jquery-turbolinks"
gem "mongoid"
gem "sass-rails"
gem "simple_form"
gem "turbolinks"
gem "uglifier"

source "https://rails-assets.org" do
  gem "rails-assets-raty"
end

group :development do
  gem "guard", require: false
  gem "guard-rspec", require: false
  gem "guard-pow", require: false
  gem "terminal-notifier-guard", require: false
  gem "rb-fsevent", require: false
  gem "quiet_assets"
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
  gem "webmock"
end

group :production do
  gem "rails_12factor"
  gem "heroku-deflater"
end
