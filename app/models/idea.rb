class Idea < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :body

  belongs_to :user
  has_many :contributions

  def self.all_with(params = {})
    filter = params['filter'] || 'newest'
    offset = params['offset'] || 0
    limit = params['limit'] || 10

    Idea.all
    .limit(limit.to_i)
    .offset(offset.to_i)
    .order(Idea.filter(filter))
  end

  def self.filter(filter)
    case filter.downcase
    when 'newest'
      'created_at DESC'
    end
  end

end
