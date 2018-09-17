class User < ApplicationRecord
  validates_presence_of :uid, :email, :username, :access_token

  has_many :ideas
  has_many :contributions
  has_many :comments

  def self.generate_access_token
    token = SecureRandom.uuid
    secure_digest = BCrypt::Password.new(BCrypt::Password.create(token))
    { token: token, secure_digest: secure_digest }
  end
end
