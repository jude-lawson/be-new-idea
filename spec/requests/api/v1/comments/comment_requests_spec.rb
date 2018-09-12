require 'rails_helper'

RSpec.describe 'Comment Requests' do
  before :each do
    setup_users_and_posts
  end

  describe 'PATCH /api/v1/comments/:id' do
    it 'should edit the comment specified by :id and return a 201 if successful' do
      edited_comment = { body: 'This is an edited comment' }
      comment_id = @user1_comments[0].id
      patch "/api/v1/comments/#{comment_id}", params: edited_comment.to_json

      expect(response.status).to eq(201)
      expect(Comment.find(comment_id).body).to eq(edited_comment[:body])
    end

    it 'should return a 400 with error messages if unsuccessful' do
      edited_comment = { body: 'This is an edited comment' }
      patch '/api/v1/comments/999', params: edited_comment.to_json

      feedback = JSON.parse(response.body)

      expect(response.status).to eq(400)
      expect(feedback['message']).to eq('An error has occurred')
      expect(feedback['error']).to include('ActiveRecord::RecordNotFound')
    end
  end
end
