source "https://rubygems.org"

ruby "2.5.5"

gem "bootstrap-sass"
gem "coffee-rails"
gem "devise"
gem "dotenv-rails"
gem "imdb"
gem "intercom-rails"
gem "jbuilder"
gem "jquery-rails"
gem "jquery-turbolinks"
gem "mongoid"
gem "newrelic_rpm"
gem "omdb", github: "jvanbaarsen/omdb" # for imdb find method
gem "rails", "~> 4.2.11"
gem "recursive-open-struct"
gem "rest-client"
gem "sass-rails"
gem "searchkick"
gem "simple_form"
gem "themoviedb"
gem "turbolinks"
gem "uglifier"
gem "nokogiri", "1.10.4"

source "https://rails-assets.org" do
  gem "rails-assets-bootstrap3-typeahead"
  gem "rails-assets-raty"
end

group :development do
  gem "guard", require: false
  gem "guard-pow", require: false
  gem "guard-rspec", require: false
  gem "quiet_assets"
  gem "rb-fsevent", require: false
  gem "terminal-notifier-guard", require: false
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
