# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!

require 'database_cleaner'
require 'shoulda-matchers'

DatabaseCleaner.strategy = :truncation

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
   config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before :each do
    ActiveRecord::Base.connection.execute('DELETE FROM comments')
    ActiveRecord::Base.connection.execute('DELETE FROM contributions')
    ActiveRecord::Base.connection.execute('DELETE FROM ideas')
    ActiveRecord::Base.connection.execute('DELETE FROM users')

    ActiveRecord::Base.connection.execute('ALTER SEQUENCE users_id_seq RESTART WITH 1')
    ActiveRecord::Base.connection.execute('ALTER SEQUENCE ideas_id_seq RESTART WITH 1')
    ActiveRecord::Base.connection.execute('ALTER SEQUENCE contributions_id_seq RESTART WITH 1')
    ActiveRecord::Base.connection.execute('ALTER SEQUENCE comments_id_seq RESTART WITH 1')
  end

  config.after :each do
    ActiveRecord::Base.connection.execute('DELETE FROM comments')
    ActiveRecord::Base.connection.execute('DELETE FROM contributions')
    ActiveRecord::Base.connection.execute('DELETE FROM ideas')
    ActiveRecord::Base.connection.execute('DELETE FROM users')

    ActiveRecord::Base.connection.execute('ALTER SEQUENCE users_id_seq RESTART WITH 1')
    ActiveRecord::Base.connection.execute('ALTER SEQUENCE ideas_id_seq RESTART WITH 1')
    ActiveRecord::Base.connection.execute('ALTER SEQUENCE contributions_id_seq RESTART WITH 1')
    ActiveRecord::Base.connection.execute('ALTER SEQUENCE comments_id_seq RESTART WITH 1')
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

