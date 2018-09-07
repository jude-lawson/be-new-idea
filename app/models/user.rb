class User < ApplicationRecord
  validates_presence_of :uid, :email, :username
end
