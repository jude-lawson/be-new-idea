class Contribution < ApplicationRecord
  validates_presence_of :body
  belongs_to :user

  belongs_to :idea
  has_many :comments
end
