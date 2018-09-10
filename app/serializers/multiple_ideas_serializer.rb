class MultipleIdeasSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :author

  def author
    object.user
  end

end
