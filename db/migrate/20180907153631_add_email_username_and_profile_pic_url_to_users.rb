class AddEmailUsernameAndProfilePicUrlToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email, :string
    add_column :users, :username, :string
    add_column :users, :profile_pic_url, :string
  end
end
