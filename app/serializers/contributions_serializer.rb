class ContributionsSerializer < ActiveModel::Serializer
  attributes :id, :author, :body

  has_many :comments, serializer: CommentsSerializer

  def author
    object.user
  end

end
