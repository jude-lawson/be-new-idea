require 'rails_helper'

RSpec.describe Idea do
  describe 'Validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end
  describe 'Relationships' do
    it { should belong_to(:user) }
  end
end