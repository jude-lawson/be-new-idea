# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!

require 'shoulda-matchers'

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


def setup_users_and_posts
  @user1_raw = File.read('spec/fixtures/user1.json')
  @user2_raw = File.read('spec/fixtures/user2.json')

  @user1_fixture_data = JSON.parse(@user1_raw)
  @user2_fixture_data = JSON.parse(@user2_raw)

  @user1 = User.create!(uid: @user1_fixture_data['uid'],
                        email: @user1_fixture_data['email'],
                        username: @user1_fixture_data['username'])

  @user2 = User.create!(uid: @user2_fixture_data['uid'],
                        email: @user2_fixture_data['email'],
                        username: @user2_fixture_data['username'])

  @user1_ideas = @user1_fixture_data['ideas'].map do |idea|
    idea[:user] = @user1
    idea.delete('id')
    Idea.create!(idea)
  end

  @user2_ideas = @user2_fixture_data['ideas'].map do |idea|
    idea[:user] = @user2
    idea.delete('id')
    Idea.create!(idea)
  end

  @user1_contributions = @user1_fixture_data['contributions'].map do |contribution|
    contribution[:user] = @user1
    contribution.delete('id')
    Contribution.create!(contribution)
  end

  @user2_contributions = @user2_fixture_data['contributions'].map do |contribution|
    contribution[:user] = @user2
    contribution.delete('id')
    Contribution.create!(contribution)
  end

  @user1_comments = @user1_fixture_data['comments'].map do |comment|
    comment[:user] = @user1
    comment.delete('id')
    Comment.create!(comment)
  end

  @user2_comments = @user2_fixture_data['comments'].map do |comment|
    comment[:user] = @user2
    comment.delete('id')
    Comment.create!(comment)
  end
end
