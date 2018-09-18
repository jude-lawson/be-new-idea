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

  def self.create_with_token(user_info)
    token_set = User.generate_access_token
    user_info[:access_token] = token_set[:secure_digest]

    if user = User.find_by(user_info)
      { db_memo: 'found', user: user }
    else
      user = User.create!(user_info)
      { db_memo: 'created', user: user, token: token_set[:token] }
    end
  end
end
