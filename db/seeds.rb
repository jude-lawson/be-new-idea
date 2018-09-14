# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

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
