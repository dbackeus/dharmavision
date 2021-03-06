# This file is copied to spec/ when you run "rails generate rspec:install"
ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
# Add additional requires below this line. Rails is not loaded until this point!
require "webmock/rspec"

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include FactoryGirl::Syntax::Methods

  config.use_transactional_examples = true

  config.before do
    I18n.locale = :en
    Time.zone = "UTC"

    WebMock.disable_net_connect!(allow_localhost: true)

    stub_request(:get, "http://akas.imdb.com/title/tt0169102/combined").
      to_return(body: webmock("lagaan.html"))

    stub_request(:get, "http://akas.imdb.com/title/tt0169102/releaseinfo").
      to_return(body: webmock("lagaan_releaseinfo.html"))

    stub_request(:get, "http://api.themoviedb.org/3/find/tt0169102?api_key=themoviedb_api_key&external_source=imdb_id").
      to_return(body: webmock("themoviedb.org/find_lagaan.json"))

    stub_request(:get, "http://api.themoviedb.org/3/movie/19666?api_key=themoviedb_api_key&append_to_response=alternative_titles,releases").
      to_return(body: webmock("themoviedb.org/lagaan.json"))
  end

  config.render_views

  config.infer_spec_type_from_file_location!
end

def webmock(file)
  File.read("spec/fixtures/webmock/#{file}")
end
