require 'rails_helper'

RSpec.describe 'User Requests' do
  context 'POST /api/v1/users' do
    it 'should create a user and return a 204 if successful' do
      body = { id: 3, uid: 'aabbcc123456', email: 'notanemail@na.moc', username: 'notauser' }.to_json

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

  context 'GET /api/v1/user/:id' do
    it 'should return all of the user\'s data as well as their ideas, comments, and contributions' do
      get "/api/v1/users/#{@user1.id}"

      expect(response.status).to eq(200)
      expect(response.body).to eq(@user1_raw)
    end

    it 'should return a 404 if the user cannot be found' do
      get '/api/v1/users/999'

      expected_error = "ActiveRecord::RecordNotFound: Couldn't find User with 'id'=999"

      expect(response.status).to eq(404)
      expect(JSON.parse(response.body)['message']).to eq('An error has occurred.')
      expect(JSON.parse(response.body)['error']).to include(expected_error)
    end
  end
end
