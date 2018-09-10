#  IDEA -- Some idea title
  #  Idea body....
  #  ↳ Contribution 1 - contribution body
  #     ↳ Comment 1 - comment body for contribution 1 
  #     ↳ Comment 2 - comment body for contribution 1
  #     ↳ Comment 3 - comment body for contribution 1

  #  ↳ Contribution 2 - contribution body
  #     ↳ Comment 1 - comment body for contribution 2 
  #     ↳ Comment 2 - comment body for contribution 2
  #     ↳ Comment 3 - comment body for contribution 2

require 'rails_helper'

RSpec.describe Idea do
  describe 'Validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end
  describe 'Relationships' do
    it { should belong_to(:user) }
    it { should have_many(:contributions) }
  end
end
