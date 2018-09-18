require 'rails_helper'

RSpec.describe 'Edit Idea Requests' do
  before :each do
    setup_users_and_posts
  end

  describe 'PATCH /api/v1/ideas/:id' do
    it 'should edit the idea and return a 201 if successful' do
      edited_idea_content = { title: 'A new title', body: 'This is some new content for the idea' }
      edited_idea_id = @user1_ideas[0].id

      auth = JwtService.encode({ uid: @user1.uid, access_token: @user1_creation_data[:token] })
  
      patch "/api/v1/ideas/#{edited_idea_id}", params: edited_idea_content.to_json, headers: { 'Authorization' => auth }

      expect(response.status).to eq(201)
      expect(Idea.find(@user1_ideas[0].id).body).to eq(edited_idea_content[:body])
      expect(Idea.find(@user1_ideas[0].id).title).to eq(edited_idea_content[:title])
    end
  
    it 'should return a 400 error with standard error message if unsuccessful' do
      edited_idea_content = { title: 'A new title', body: 'This is some new content for the idea' }

      auth = JwtService.encode({ uid: @user1.uid, access_token: @user1_creation_data[:token] })

      patch "/api/v1/ideas/999", params: edited_idea_content.to_json, headers: { 'Authorization' => auth }

      feedback = JSON.parse(response.body)

      expect(response.status).to eq(400)
      expect(feedback['message']).to eq('An error has occurred.')
      expect(feedback['error']).to include('ActiveRecord::RecordNotFound')
    end

    it 'should return a 401 if a bad authentication is given' do
      edited_idea_content = { title: 'A new title', body: 'This is some new content for the idea' }
      edited_idea_id = @user1_ideas[0].id

      auth = JwtService.encode({ uid: @user1.uid, access_token: 'not a real token' })
  
      patch "/api/v1/ideas/#{edited_idea_id}", params: edited_idea_content.to_json, headers: { 'Authorization' => auth }

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['message']).to eq('Bad Authentication')
    end

    it 'should return a 401 if authorization header is malformed' do
      edited_idea_content = { title: 'A new title', body: 'This is some new content for the idea' }
      edited_idea_id = @user1_ideas[0].id

      auth = "This is not great"
  
      patch "/api/v1/ideas/#{edited_idea_id}", params: edited_idea_content.to_json, headers: { 'Authorization' => auth }

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['message']).to eq('Authorization header was not provided or is mis-structured.')
    end

    it 'should return a 401 if authorization header is not provided' do
      edited_idea_content = { title: 'A new title', body: 'This is some new content for the idea' }
      edited_idea_id = @user1_ideas[0].id
  
      patch "/api/v1/ideas/#{edited_idea_id}", params: edited_idea_content.to_json

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['message']).to eq('Authorization header was not provided or is mis-structured.')
    end
  end
end
