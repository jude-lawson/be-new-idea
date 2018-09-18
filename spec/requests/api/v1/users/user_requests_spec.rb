require 'rails_helper'

RSpec.describe 'User Requests' do
  before :each do
    setup_users_and_posts
  end
  
  describe 'POST /api/v1/users' do
    it 'should create a user and return a 201 if successful' do
      uid = 'aabbcc123456'
      email = 'notanemail@na.moc'
      username = 'notauser'
      body = { uid: uid, email: email, username: username }.to_json

      post '/api/v1/users', params: body

      ret_user = JSON.parse(response.body)
      expect(response.status).to eq(201)
      expect(ret_user['uid']).to eq(uid)
      expect(ret_user['email']).to eq(email)
      expect(ret_user['username']).to eq(username)
      expect(response.headers).to include('Authorization')
      expect(response.headers['Authorization']).to be_a(String)
    end

    it 'should return a 200 if the user already existed successful' do
      uid = 'aabbcc123456'
      email = 'notanemail@na.moc'
      username = 'notauser'
      body = { uid: uid, email: email, username: username }
      User.create!(body)

      post '/api/v1/users', params: body.to_json

      ret_user = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(ret_user['uid']).to eq(uid)
      expect(ret_user['email']).to eq(email)
      expect(ret_user['username']).to eq(username)
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

  describe 'GET /api/v1/user/:id' do
    it 'should return all of the user\'s data as well as their ideas, comments, and contributions' do
      get "/api/v1/users/#{@user1.id}"

      response_data = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(response_data).to include('id' => @user1_fixture_data['id'])
      expect(response_data).to include('uid' => @user1_fixture_data['uid'])
      expect(response_data).to include('email' => @user1_fixture_data['email'])
      expect(response_data).to include('username' => @user1_fixture_data['username'])


      expect(response_data['ideas'][0]).to include('id' => 1)
      expect(response_data['ideas'][0]).to include('title' => @user1_fixture_data['ideas'][0]['title'])
      expect(response_data['ideas'][0]).to include('body' => @user1_fixture_data['ideas'][0]['body'])
      expect(response_data['ideas'][0]).to include("created_at")
      expect(response_data['ideas'][0]).to include("updated_at")

      expect(response_data['contributions'][0]).to include('id' => 1)
      expect(response_data['contributions'][0]).to include('body' => @user1_fixture_data['contributions'][0]['body'])
      expect(response_data['contributions'][0]).to include("created_at")
      expect(response_data['contributions'][0]).to include("updated_at")

      expect(response_data['comments'][0]).to include('id' => 1)
      expect(response_data['comments'][0]).to include('body' => @user1_fixture_data['comments'][0]['body'])
      expect(response_data['comments'][0]).to include("created_at")
      expect(response_data['comments'][0]).to include("updated_at")

      expect(response_data['comments'][1]).to include('id' => 2)
      expect(response_data['comments'][1]).to include('body' => @user1_fixture_data['comments'][1]['body'])
      expect(response_data['comments'][1]).to include("created_at")
      expect(response_data['comments'][1]).to include("updated_at")
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
