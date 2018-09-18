# GET IDEA
# {
#   title: string,
#   body: text,
#   author: {username:string,
#            email:string,
#            uid:string}
#   contributions:[ {body:text,
#                    author: { username:string,
#                              email:string,
#                              uid:string}
#                    comments:[
#                               {body: text, author: { username:string,email:string,uid:string}}
#                               {body: text, author: { username:string,email:string,uid:string}}
#                               {body: text, author: { username:string,email:string,uid:string}}
#                               ]
#                             },
#                   {body:text,
#                    author: { username:string,
#                              email:string,
#                              uid:string}
#                    comments:[
#                               {body: text, author: { username:string,email:string,uid:string}}
#                               {body: text, author: { username:string,email:string,uid:string}}
#                               {body: text, author: { username:string,email:string,uid:string}}
#                               ]}
#                    ]
#   }

require 'rails_helper'

RSpec.describe 'Idea Requests' do

  describe 'get ideas' do
    describe 'without parameters' do

      it 'should return the 10 newest ideas' do

        username = 'my_username'
        uid = "abc123"
        email = "email@place.com"
        profile_pic_url = "www.image.com"
        user = User.create_with_token(uid:uid , email:email, username:username, profile_pic_url:profile_pic_url)[:user]

        new_title =  "My big new idea"
        new_body = "Many smart things go here"
        10.times do
          Idea.create!(title: new_title, body: new_body, user:user, created_at: Time.now)
        end

        5.times do
          Idea.create!(title: "My Old Crazy idea", body:"Many Older things go here", user:user, created_at: 1.day.ago)
        end

        get '/api/v1/ideas'
        ideas = JSON.parse(response.body)
        expect(ideas.length).to eq(10)
        first_idea = ideas.first
        expect(first_idea["title"]).to eq(new_title)
        expect(first_idea["body"]).to eq(new_body)
        user_json = first_idea['author']
        expect(user_json["username"]).to eq(username)
        expect(user_json["uid"]).to eq(uid)
        expect(user_json["email"]).to eq(email)
        expect(user_json["profile_pic_url"]).to eq(profile_pic_url)
      end
    end

    describe 'with parameters' do
      describe '?filter=X' do
      end

      describe '?limit=X' do
        it 'should return the number specified in the limit' do
          Idea.delete_all
          username = 'my_username'
          uid = "abc123"
          email = "email@place.com"
          profile_pic_url = "www.image.com"
          user = User.create_with_token(uid:uid , email:email, username:username, profile_pic_url:profile_pic_url)[:user]

          new_title =  "My big new idea"
          new_body = "Many smart things go here"
          10.times do
            Idea.create!(title: new_title, body: new_body, user:user, created_at: Time.now)
          end

          5.times do
            Idea.create!(title: "My Old Crazy idea", body:"Many Older things go here", user:user, created_at: 1.day.ago)
          end

          get '/api/v1/ideas?limit=15'
          ideas = JSON.parse(response.body)
          expect(ideas.length).to eq(15)
          first_idea = ideas.first
          expect(first_idea["title"]).to eq(new_title)
          expect(first_idea["body"]).to eq(new_body)
        end
      end

      describe '?offset=X' do
        
        it 'should offset the results, according to the filter(default newest)' do
          Idea.delete_all
          username = 'my_username'
          uid = "abc123"
          email = "email@place.com"
          profile_pic_url = "www.image.com"
          user = User.create_with_token(uid:uid , email:email, username:username, profile_pic_url:profile_pic_url)[:user]
  
          20.times do |n|
            title =  "#{n+1}"
            body = "Many smart things go here"
            Idea.create!(title: title, body: body, user:user, created_at: ((n+1)/2).hours.ago)
          end
          get '/api/v1/ideas?offset=10'
          ideas = JSON.parse(response.body)
          expect(ideas.count).to eq(10)
          expect(ideas.first['title']).to eq("10")
          expect(ideas[-1]['title']).to eq("20")
        end

      end

    end
  end
end
