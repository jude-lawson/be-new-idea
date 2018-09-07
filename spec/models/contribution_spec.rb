require 'rails_helper'

RSpec.describe Idea do
  describe 'Validations' do
    it { should validate_presence_of(:body) }
  end
  describe 'Relationships' do
    it { should belong_to(:user) }
    it { should belong_to(:idea) }
  end
end