class UserSerializer < ActiveModel::Serializer
  attributes :id, :uid, :email, :username, :ideas, :contributions, :comments, :profile_pic_url
  def ideas
    object.ideas
  end

  def contributions
    object.contributions
  end

  def comments
    object.comments
  end
end
