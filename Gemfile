source "https://rubygems.org"

ruby File.read(".ruby-version").chomp

gem "activerecord-explain-analyze"
gem "bootsnap", require: false
gem "bootstrap-sass"
gem "coffee-rails"
gem "devise"
gem "intercom-rails"
gem "jbuilder"
gem "jquery-rails"
gem "newrelic_rpm"
gem "nokogiri"
gem "omniauth-google-oauth2"
gem "pg"
gem "pg_search"
gem "puma"
gem "rails"
gem "sass-rails"
gem "sprockets", "<4"
gem "simple_form"
gem "turbolinks"
gem "typhoeus"
gem "uglifier"

source "https://rails-assets.org" do
  gem "rails-assets-bootstrap3-typeahead"
  gem "rails-assets-raty"
end

group :development do
  gem "guard", require: false
  gem "guard-pow", require: false
  gem "guard-rspec", require: false
  gem "listen"
  gem "rb-fsevent", require: false
  gem "spring"
  gem "spring-watcher-listen"
  gem "terminal-notifier-guard", require: false
  gem "web-console"
end

group :development, :test do
  gem "byebug"
  gem "dotenv-rails"
  gem "rspec-rails"
end

group :test do
  gem "factory_girl_rails"
  gem "webmock"
end

group :production do
  gem "heroku-deflater"
end
