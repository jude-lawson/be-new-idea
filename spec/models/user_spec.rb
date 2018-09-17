require 'rails_helper'

RSpec.describe User do
  describe 'Validations' do
    it { should validate_presence_of(:uid) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:username) }
    it { should have_db_column(:profile_pic_url) }
    it { should validate_presence_of(:access_token) }
  end

  describe 'Relationships' do
    it { should have_many(:ideas) }
    it { should have_many(:contributions) }
    it { should have_many(:comments) }
  end

  describe 'Class Methods' do
    describe '::generate_access_token' do
      it 'should create an access token for the frontend and store a secure version in the db' do
        token_set = User.generate_access_token
        expect(token_set).to include(token: be_a(String), secure_digest: be_a(BCrypt::Password)) 
      end
    end
  end
end
