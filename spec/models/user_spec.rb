require 'rails_helper'

RSpec.describe User do
  describe 'Validations' do
    it { should validate_presence_of(:uid) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:username) }
    it { should have_db_column(:profile_pic_url) }
  end

  describe 'Relationships' do
    it { should have_many(:ideas) }
    it { should have_many(:contributions) }
    it { should have_many(:comments) }
  end
end
