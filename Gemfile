source "https://rubygems.org"

ruby "2.5.8"

gem "bootstrap-sass"
gem "coffee-rails"
gem "devise"
gem "dotenv-rails"
gem "intercom-rails"
gem "jbuilder"
gem "jquery-rails"
gem "mongoid", "~> 5.0"
gem "newrelic_rpm"
gem "nokogiri", "1.10.4"
gem "omniauth-google-oauth2"
gem "pg", "~> 0.20"
gem "puma"
gem "rails", "~> 4.2.11"
gem "rake", "<11" # https://stackoverflow.com/questions/35893584/nomethoderror-undefined-method-last-comment-after-upgrading-to-rake-11
gem "recursive-open-struct"
gem "rest-client"
gem "sass-rails"
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
  gem "quiet_assets"
  gem "rb-fsevent", require: false
  gem "terminal-notifier-guard", require: false
  gem "web-console"
end

group :development, :test do
  gem "byebug"
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
