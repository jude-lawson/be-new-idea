require 'rails_helper'

RSpec.describe 'Comment Requests' do
  before :each do
    setup_users_and_posts
  end

  describe 'PATCH /api/v1/comments/:id' do
    it 'should edit the comment specified by :id and return a 201 if successful' do
      edited_comment = { body: 'This is an edited comment' }
      comment_id = @user1_comments[0].id

      auth = JwtService.encode({ uid: @user1.uid, access_token: @user1_creation_data[:token] })

      patch "/api/v1/comments/#{comment_id}", params: edited_comment.to_json, headers: { 'Authorization' => auth }

      expect(response.status).to eq(201)
      expect(Comment.find(comment_id).body).to eq(edited_comment[:body])
    end

    it 'should return a 400 with error messages if unsuccessful' do
      edited_comment = { body: 'This is an edited comment' }

      auth = JwtService.encode({ uid: @user1.uid, access_token: @user1_creation_data[:token] })

      patch '/api/v1/comments/999', params: edited_comment.to_json, headers: { 'Authorization' => auth }

      feedback = JSON.parse(response.body)
      
      expect(feedback['message']).to eq('An error has occurred.')
      expect(feedback['error']).to include('ActiveRecord::RecordNotFound')
    end

    it 'should return a 401 if authentication is unsuccessful' do
      edited_comment = { body: 'This is an edited comment' }
      comment_id = @user1_comments[0].id

      auth = JwtService.encode({ uid: @user1.uid, access_token: 'this is not a real token' })

      patch "/api/v1/comments/#{comment_id}", params: edited_comment.to_json, headers: { 'Authorization' => auth }

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['message']).to eq('Bad Authentication')
    end

    it 'should return a 401 if authentication header is malformed' do
      edited_comment = { body: 'This is an edited comment' }
      comment_id = @user1_comments[0].id

      auth = 'this is not great'

      patch "/api/v1/comments/#{comment_id}", params: edited_comment.to_json, headers: { 'Authorization' => auth }

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['message']).to eq('Authorization header was not provided or is mis-structured.')
    end

    it 'should reutrn a 401 if authentication header is missing' do
      edited_comment = { body: 'This is an edited comment' }
      comment_id = @user1_comments[0].id

      auth = 'this is not great'

      patch "/api/v1/comments/#{comment_id}", params: edited_comment.to_json, headers: { 'Authorization' => auth }

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['message']).to eq('Authorization header was not provided or is mis-structured.')
    end
  end

  describe 'POST /api/v1/contributions/:id/comments' do
    it 'should create a comment with the associated contribution and return a 201' do
      new_comment = { 
        user_id: @user2.id,
        body: "This is a kind comment on someone's contribution"
      }.to_json

      auth = JwtService.encode({ uid: @user2.uid, access_token: @user2_creation_data[:token] })

      post "/api/v1/contributions/#{@user1_contributions[0].id}/comments", params: new_comment, headers: { 'Authorization' => auth }

      expect(response.status).to eq(201)
      expect(Comment.last.id).to eq(4)
      expect(Comment.last.body).to eq("This is a kind comment on someone's contribution")
    end

    it 'should return a 400 error with error messages if unsuccessful' do
      errant_comment = {}.to_json

      auth = JwtService.encode({ uid: @user2.uid, access_token: @user2_creation_data[:token] })

      post "/api/v1/contributions/#{@user1_contributions[0].id}/comments", params: errant_comment, headers: { 'Authorization' => auth }

      feedback = JSON.parse(response.body)

      expect(response.status).to eq(400)
      expect(feedback['message']).to eq('An error has occurred.')
      expect(feedback['error']).to include('ActiveRecord::RecordInvalid')
    end

    it 'should return a 401 if authentication is unsuccessful' do
      new_comment = { 
        user_id: @user2.id,
        body: "This is a kind comment on someone's contribution"
      }.to_json

      auth = JwtService.encode({ uid: @user2.uid, access_token: 'this is not a real token' })

      post "/api/v1/contributions/#{@user1_contributions[0].id}/comments", params: new_comment, headers: { 'Authorization' => auth }

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['message']).to eq('Bad Authentication')
    end

    it 'should return a 401 if authentication header is malformed' do
      new_comment = { 
        user_id: @user2.id,
        body: "This is a kind comment on someone's contribution"
      }.to_json

      auth = 'this is not great'

      post "/api/v1/contributions/#{@user1_contributions[0].id}/comments", params: new_comment, headers: { 'Authorization' => auth }

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['message']).to eq('Authorization header was not provided or is mis-structured.')
    end

    it 'should reutrn a 401 if authentication header is missing' do
      new_comment = { 
        user_id: @user2.id,
        body: "This is a kind comment on someone's contribution"
      }.to_json

      post "/api/v1/contributions/#{@user1_contributions[0].id}/comments", params: new_comment

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['message']).to eq('Authorization header was not provided or is mis-structured.')
    end
  end
end
