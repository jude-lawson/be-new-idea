require 'rails_helper'

RSpec.describe 'Contribution Requests' do
  before :each do
    setup_users_and_posts
  end

  describe 'POST /api/v1/ideas/:id/contributions' do
    it 'should create a contribution associated with the specified idea' do
      body = { 
        user_id: @user1.id,
        body: 'This is a super cool contribution to Idea 2'
      }.to_json

      post "/api/v1/ideas/#{@user2_ideas[0].id}/contributions", params: body

      expect(response.status).to eq(201)
      expect(Contribution.last.id).to eq(3)
      expect(Contribution.last.body).to eq('This is a super cool contribution to Idea 2')
    end

    it 'should return a 400 with an error message if there was an issue creating the contribution' do
      errant_body = {}.to_json

      post "/api/v1/ideas/#{@user2_ideas[0].id}/contributions", params: errant_body

      parsed_response = JSON.parse(response.body)

      expect(response.status).to eq(400)
      expect(parsed_response['message']).to eq('An error has occurred.')
      expect(parsed_response['error']).to include('ActiveRecord::RecordInvalid')
      expect(parsed_response['error']).to include('Validation failed')
    end
  end

  describe 'PATCH /api/v1/contributions/:id' do
    it 'should edit a contribution and return a 201 if successful' do
      new_contribution_body = { body: 'This is the new, edited body for Contribution 1 for Idea 1' }

      patch "/api/v1/contributions/#{@user1_contributions[0].id}", params: new_contribution_body.to_json

      expect(response.status).to eq(201)
      expect(Contribution.find(1).body).to eq(new_contribution_body[:body])
    end

    it 'should return a 400 with an error message if unsucessful' do
      new_contribution_body = { body: 'This is the new, edited body for Contribution 1 for Idea 1' }

      patch "/api/v1/contributions/999", params: new_contribution_body.to_json

      feedback = JSON.parse(response.body)

      expect(response.status).to eq(400)
      expect(feedback['message']).to eq('An error has occurred')
      expect(feedback['error']).to include('ActiveRecord::RecordNotFound')
    end
  end
end
