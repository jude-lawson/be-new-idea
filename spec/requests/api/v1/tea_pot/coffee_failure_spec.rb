require 'rails_helper'

RSpec.describe 'Coffee Creation' do
  describe 'get api v1 coffee' do
    it "should yell at you for attempting to make coffee. I'm a teapot damnit. I can't make coffee" do
      post '/api/v1/coffee'
      ret_resp = JSON.parse(response.body)
      expect(response.status).to eq(418)
      expect(ret_resp['message']).to eq("I'm a Teapot!")
    end
  end
end
