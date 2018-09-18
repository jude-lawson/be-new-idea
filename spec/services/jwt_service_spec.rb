require 'rails_helper'

RSpec.describe JwtService do
  describe 'Class Methods' do
    describe '::encode and ::decode' do
      it 'should be able to take a hash, encode it, and then decode it to the same hash' do
        secret = { access_token: 'this-is-super-secret', uid: 'abc123' }
        encoded = JwtService.encode(secret)
        decoded = JwtService.decode(encoded)
        expect(decoded[0]['access_token']).to eq(secret[:access_token])
        expect(decoded[0]['uid']).to eq(secret[:uid])
      end
    end
  end
end
