class User < ApplicationRecord
  validates_presence_of :uid, :email, :username

  has_many :ideas
  has_many :contributions
  has_many :comments
end
