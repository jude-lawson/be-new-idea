require 'rails_helper'

RSpec.describe 'Edit Idea Requests' do
  before :each do
    setup_users_and_posts
  end

  describe 'PATCH /api/v1/ideas/:id' do
    it 'should edit the idea and return a 201 if successful' do
      edited_idea_content = { title: 'A new title', body: 'This is some new content for the idea' }
      edited_idea_id = @user1_ideas[0].id
  
      patch "/api/v1/ideas/#{edited_idea_id}", params: edited_idea_content.to_json

      expect(response.status).to eq(201)
      expect(Idea.find(@user1_ideas[0].id).body).to eq(edited_idea_content[:body])
      expect(Idea.find(@user1_ideas[0].id).title).to eq(edited_idea_content[:title])
    end
  
    it 'should return a 400 error with standard error message if unsuccessful' do
      edited_idea_content = { title: 'A new title', body: 'This is some new content for the idea' }
      patch "/api/v1/ideas/999", params: edited_idea_content.to_json

      feedback = JSON.parse(response.body)

      expect(response.status).to eq(400)
      expect(feedback['message']).to eq('An error has occurred.')
      expect(feedback['error']).to include('ActiveRecord::RecordNotFound')
    end
  end
end
