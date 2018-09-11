class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :uid, :email, :username, :profile_pic_url
end
