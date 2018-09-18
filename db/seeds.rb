# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# #   Character.create(name: 'Luke', movie: movies.first)

# @user1_raw = File.read('spec/fixtures/user1.json')
#   @user2_raw = File.read('spec/fixtures/user2.json')

#   @user1_fixture_data = JSON.parse(@user1_raw)
#   @user2_fixture_data = JSON.parse(@user2_raw)

#   @user1 = User.create!(uid: @user1_fixture_data['uid'],
#                         email: @user1_fixture_data['email'],
#                         username: @user1_fixture_data['username'])

#   @user2 = User.create!(uid: @user2_fixture_data['uid'],
#                         email: @user2_fixture_data['email'],
#                         username: @user2_fixture_data['username'])

#   @user1_ideas = @user1_fixture_data['ideas'].map do |idea|
#     idea[:user] = @user1
#     idea.delete('id')
#     Idea.create!(idea)
#   end

#   @user2_ideas = @user2_fixture_data['ideas'].map do |idea|
#     idea[:user] = @user2
#     idea.delete('id')
#     Idea.create!(idea)
#   end

#   @user1_contributions = @user1_fixture_data['contributions'].map do |contribution|
#     contribution[:user] = @user1
#     contribution.delete('id')
#     Contribution.create!(contribution)
#   end

#   @user2_contributions = @user2_fixture_data['contributions'].map do |contribution|
#     contribution[:user] = @user2
#     contribution.delete('id')
#     Contribution.create!(contribution)
#   end

#   @user1_comments = @user1_fixture_data['comments'].map do |comment|
#     comment[:user] = @user1
#     comment.delete('id')
#     Comment.create!(comment)
#   end

#   @user2_comments = @user2_fixture_data['comments'].map do |comment|
#     comment[:user] = @user2
#     comment.delete('id')
#     Comment.create!(comment)
#   end

def create_comment(contribution)
  contribution.comments.create!(user: rand_user, body: body(15))

end

def create_contribution(idea)
  idea.contributions.create!(user: rand_user, body: body(15) )
end

def create_idea(user)
  user.ideas.create!(body: body(15), title: Faker::Hacker.say_something_smart)
end

def create_user
  User.create!(uid:Faker::Device.serial, username: name, email: Faker::Internet.email, profile_pic_url: Faker::Avatar.image)
end

def body(num)
  Faker::Hipster.sentence(num, true)
end

def rand_user
  User.all.sample
end

def title
  case rand(3)
  when 0
    Faker::Hacker.say_something_smart
  when 1
    Faker::Company.catch_phrase
  when 2
  end
end

def name
  case rand(3)
  when 0
    Faker::BossaNova.artist
  when 1
    Faker::Ancient.hero
  when 2
    Faker::RuPaul.queen
  end
end

x = (20 + rand(15))
x.times do |n|
  user = create_user
  puts "#{n} of #{x}"
  (5 + rand(10)).times do
    idea = create_idea(user)
    (5 + rand(10)).times do
      contribution = create_contribution(idea)
      (5 + rand(10)).times do
        comment = create_comment(contribution)
      end
    end
  end
end