require 'rails_helper'

RSpec.describe 'Idea Creation' do
  describe 'post api/v1/ideas' do
    it 'should create a new idea with viable params' do
      username = 'my_username'
      uid = "abc123"
      email = "email@place.com"
      profile_pic_url = "www.image.com"
      user = User.create_with_token(uid:uid , email:email, username:username, profile_pic_url:profile_pic_url)[:user]

      title = "My big new idea"
      body = "This is the body"
      new_idea_params = {
        user_id: user.id,
        title: title,
        body: body
      }.to_json

      post '/api/v1/ideas', params: new_idea_params
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
      user = User.create_with_token(uid:uid , email:email, username:username, profile_pic_url:profile_pic_url)[:user]

      body = "This is the body"
      new_idea_params = {
        user_id: user.id,
        body: body
      }.to_json

      post '/api/v1/ideas', params: new_idea_params
      
      returned_resp = JSON.parse(response.body)
      expect(response.status).to eq(400)
      expect(returned_resp['message']).to eq('An error has occurred.')
    end
  end
end
