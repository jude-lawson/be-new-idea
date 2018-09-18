require 'rails_helper'

RSpec.describe 'Idea Creation' do
  describe 'post api/v1/ideas' do
    it 'should create a new idea with viable params' do
      username = 'my_username'
      uid = "abc123"
      email = "email@place.com"
      profile_pic_url = "www.image.com"
      creation_response = User.create_with_token(uid:uid , email:email, username:username, profile_pic_url:profile_pic_url)
      access_token = creation_response[:token]
      user = creation_response[:user]

      title = "My big new idea"
      body = "This is the body"
      new_idea_params = {
        user_id: user.id,
        title: title,
        body: body
      }.to_json

      post '/api/v1/ideas', params: new_idea_params, headers: { 'Authorization' => JwtService.encode({ uid: uid, access_token: access_token }) }
      returned_resp = JSON.parse(response.body)
      
      idea_in_db = Idea.find_by_title(title)
      expect(idea_in_db).to_not be_nil
      expect(idea_in_db.body).to eq(body)
      expect(response.status).to eq(201)
      expect(returned_resp['message']).to eq('Idea successfully created')
    end

    it 'should not create the idea with missing fields' do
      username = 'my_username'
      uid = "abc123"
      email = "email@place.com"
      profile_pic_url = "www.image.com"
      creation_response = User.create_with_token(uid:uid , email:email, username:username, profile_pic_url:profile_pic_url)
      access_token = creation_response[:token]
      user = creation_response[:user]

      body = "This is the body"
      new_idea_params = {
        user_id: user.id,
        body: body
      }.to_json

      post '/api/v1/ideas', params: new_idea_params, headers: { 'Authorization' => JwtService.encode({ uid: uid, access_token: access_token }) }
      
      returned_resp = JSON.parse(response.body)
      expect(response.status).to eq(400)
      expect(returned_resp['message']).to eq('An error has occurred.')
    end

    it 'should return a 401 if the user is not authenticated' do
      username = 'my_username'
      uid = "abc123"  
      email = "email@place.com"
      profile_pic_url = "www.image.com"
      title = "My big new idea"
      user = User.create_with_token(uid:uid , email:email, username:username, profile_pic_url:profile_pic_url)[:user]

      body = "This is the body"
      new_idea_params = {
        user_id: user.id,
        title: title,
        body: body
      }.to_json

      errant_auth = JwtService.encode({ uid: uid, access_token: 'not a real token' })

      post '/api/v1/ideas', params: new_idea_params, headers: {'Authorization' => errant_auth }

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['message']).to eq('Bad Authentication')
    end

    it 'should return a 401 error if JWT is missing or malformed' do
      username = 'my_username'
      uid = "abc123"  
      email = "email@place.com"
      profile_pic_url = "www.image.com"
      title = "My big new idea"
      user = User.create_with_token(uid:uid , email:email, username:username, profile_pic_url:profile_pic_url)[:user]

      body = "This is the body"
      new_idea_params = {
        user_id: user.id,
        title: title,
        body: body
      }.to_json

      errant_auth = "uid: uid, access_token: 'not a real token'"

      post '/api/v1/ideas', params: new_idea_params, headers: {'Authorization' => errant_auth }

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['message']).to eq('Authorization header was not provided or is mis-structured.')
    end
  end
end
