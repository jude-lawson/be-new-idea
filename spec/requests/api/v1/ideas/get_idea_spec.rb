require 'rails_helper'

RSpec.describe 'Get Idea request' do

  describe 'idea attributes' do
    it 'should return the specific ideas attributes' do
      username = 'my_username'
      uid = "abc123"
      email = "email@place.com"
      profile_pic_url = "www.image.com"
      user = User.create!(uid:uid , email:email, username:username, profile_pic_url:profile_pic_url)
      title = "It's uber, but for dogs, but with facebook."
      body = "i don't actually know"

      db_idea = Idea.create!(title: title, body:body, user:user)

      get "/api/v1/ideas/#{db_idea.id}"
      idea = JSON.parse(response.body)

      expect(idea['title']).to eq(title)
      expect(idea['body']).to eq(body)

      returned_user = idea['author']

      expect(returned_user['uid']).to eq(uid)
      expect(returned_user['email']).to eq(email)
      expect(returned_user['profile_pic_url']).to eq(profile_pic_url)
      expect(returned_user['uid']).to eq(uid)
    end
  end
  describe 'sad path' do
    it 'should return a 404' do
      get "/api/v1/ideas/1"
      expect(response.status).to eq(404)

    end
  end
  describe 'contributions' do
    it 'should return all related contributions' do
      username = 'my_username'
      uid = "abc123"
      email = "email@place.com"
      profile_pic_url = "www.image.com"
      
      user = User.create!(uid:uid , email:email, username:username, profile_pic_url:profile_pic_url)
      idea = Idea.create!(title: "It's uber, but for dogs, but with facebook.", body: "i don't actually know", user:user)
      13.times do
        idea.contributions.create!(body: "some 'meaningful' contribution", user:user)
      end

      get "/api/v1/ideas/#{idea.id}"

      ret_idea = JSON.parse(response.body)
      contributions = ret_idea['contributions']
      expect(contributions.length).to eq(13)
      expect(contributions.first['body']).to eq("some 'meaningful' contribution")
      expect(contributions.first['author']['username']).to eq(user.username)
      expect(contributions.first['author']['uid']).to eq(user.uid)
      expect(contributions.first['author']['email']).to eq(user.email)      
    end
  end

  describe 'comments' do
    it 'should return the comments for each contribution' do
      username = 'my_username'
      uid = "abc123"
      email = "email@place.com"
      profile_pic_url = "www.image.com"
      
      user = User.create!(uid:uid , email:email, username:username, profile_pic_url:profile_pic_url)
      idea = Idea.create!(title: "It's uber, but for dogs, but with facebook.", body: "i don't actually know", user:user)
      2.times do
        contr = idea.contributions.create!(body: "some 'meaningful' contribution", user:user)
        3.times do
          contr.comments.create!(body: "A COMMENT!!", user: user)
        end 
      end

      get "/api/v1/ideas/#{idea.id}"
      ret_idea = JSON.parse(response.body)
      contributions = ret_idea['contributions']
      contributions.each do |contribution|
        expect(contribution['comments'].length).to eq(3)
        expect(contribution['comments'].first['body']).to eq("A COMMENT!!")
        expect(contribution['comments'].first['author']).to_not be_nil
      end
    end
  end
end