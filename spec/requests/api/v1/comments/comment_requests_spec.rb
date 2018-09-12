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
      
      expect(feedback['message']).to eq('An error has occurred.')
      expect(feedback['error']).to include('ActiveRecord::RecordNotFound')
    end
  end

  describe 'POST /api/v1/contributions/:id/comments' do
    it 'should create a comment with the associated contribution and return a 201' do
      new_comment = { 
        user_id: @user2.id,
        body: "This is a kind comment on someone's contribution"
      }.to_json

      post "/api/v1/contributions/#{@user1_contributions[0].id}/comments", params: new_comment

      expect(response.status).to eq(201)
      expect(Comment.last.id).to eq(4)
      expect(Comment.last.body).to eq("This is a kind comment on someone's contribution")
    end

    it 'should return a 400 error with error messages if unsuccessful' do
      errant_comment = {}.to_json

      post "/api/v1/contributions/#{@user1_contributions[0].id}/comments", params: errant_comment

      feedback = JSON.parse(response.body)

      expect(response.status).to eq(400)
      expect(feedback['message']).to eq('An error has occurred.')
      expect(feedback['error']).to include('ActiveRecord::RecordInvalid')
    end
  end
end
