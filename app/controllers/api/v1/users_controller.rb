class Api::V1::UsersController < ApplicationController
  def create
    safe_query message:" User creation was unsuccessful." do
      user_data = JSON.parse(request.body.string)
      User.create!(user_data)
      render status: 204
    end
  end

  def show
    safe_query status:404 do
      user = User.find(params[:id])
      render status: 200, json: user
    end
  end
end
