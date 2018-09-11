class CommentsSerializer < ActiveModel::Serializer
  attributes :id, :body, :author

  def author
    object.user
  end
end
