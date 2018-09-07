require 'rails_helper'

RSpec.describe 'User Requests' do
  context 'POST /api/v1/users' do
    it 'should create a user and return a 204 if successful' do
      body = { uid: 123456 }.to_json

      post '/api/v1/users', params: body

      expect(response.status).to eq(204)
    end

    it 'should return a 400 if something went wrong' do
      errant_body = { uid: '' }.to_json

      post '/api/v1/users', params: errant_body

      response_data = JSON.parse(response.body)
      expected_response = { error: 'User creation unsuccessful.'}

      expect(response.status).to eq(400)
      expect(response_data['message']).to eq('An error has occurred. User creation was unsuccessful.')
      expect(response_data['error']).to include('Validation failed: Uid can\'t be blank')
    end
  end
end
