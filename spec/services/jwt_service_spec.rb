require 'rails_helper'

RSpec.describe JwtService do
  describe 'Class Methods' do
    describe '::encode and ::decode' do
      secret = { access_token: 'this-is-super-secret', uid: 'abc123' }
      encoded = JwtService.encode(secret)
      decoded = JwtService.decode(encoded)
      expect(decoded).to eq(secret)
    end
  end
end
