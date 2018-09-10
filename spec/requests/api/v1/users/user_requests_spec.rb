require 'rails_helper'

RSpec.describe 'User Requests' do
  before :each do
    @user1_raw = File.read('spec/fixtures/user1.json')
    @user2_raw = File.read('spec/fixtures/user2.json')

    @user1_fixture_data = JSON.parse(@user1_raw)
    @user2_fixture_data = JSON.parse(@user2_raw)

    @user1 = User.create!(id: @user1_fixture_data['id'], uid: @user1_fixture_data['uid'],
                          email: @user1_fixture_data['email'], username: @user1_fixture_data['username'])
    @user2 = User.create!(id: @user2_fixture_data['id'], uid: @user2_fixture_data['uid'],
                          email: @user2_fixture_data['email'], username: @user2_fixture_data['username'])

    @user1_fixture_data['ideas'].each do |idea|
      idea[:user] = @user1
      Idea.create!(idea)
    end

    @user2_fixture_data['ideas'].each do |idea|
      idea[:user] = @user2
      Idea.create!(idea)
    end

    @user1_fixture_data['contributions'].each do |contribution|
      contribution[:user] = @user1
      Contribution.create!(contribution)
    end

    @user2_fixture_data['contributions'].each do |contribution|
      contribution[:user] = @user2
      Contribution.create!(contribution)
    end

    @user1_fixture_data['comments'].each do |comment|
      comment[:user] = @user1
      Comment.create!(comment)
    end

    @user2_fixture_data['comments'].each do |comment|
      comment[:user] = @user2
      Comment.create!(comment)
    end
  end
  
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

      response_data = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(response_data).to include('id' => @user1_fixture_data['id'])
      expect(response_data).to include('uid' => @user1_fixture_data['uid'])
      expect(response_data).to include('email' => @user1_fixture_data['email'])
      expect(response_data).to include('username' => @user1_fixture_data['username'])

      expect(response_data['ideas'][0]).to include('id' => @user1_fixture_data['ideas'][0]['id'])
      expect(response_data['ideas'][0]).to include('title' => @user1_fixture_data['ideas'][0]['title'])
      expect(response_data['ideas'][0]).to include('body' => @user1_fixture_data['ideas'][0]['body'])
      expect(response_data['ideas'][0]).to include("created_at")
      expect(response_data['ideas'][0]).to include("updated_at")

      expect(response_data['contributions'][0]).to include('id' => @user1_fixture_data['contributions'][0]['id'])
      expect(response_data['contributions'][0]).to include('body' => @user1_fixture_data['contributions'][0]['body'])
      expect(response_data['contributions'][0]).to include("created_at")
      expect(response_data['contributions'][0]).to include("updated_at")

      expect(response_data['comments'][0]).to include('id' => @user1_fixture_data['comments'][0]['id'])
      expect(response_data['comments'][0]).to include('body' => @user1_fixture_data['comments'][0]['body'])
      expect(response_data['comments'][0]).to include("created_at")
      expect(response_data['comments'][0]).to include("updated_at")

      expect(response_data['comments'][1]).to include('id' => @user1_fixture_data['comments'][1]['id'])
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
