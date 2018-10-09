class Api::V1::UsersController < ApplicationController
  def create
    safe_query message:" User creation was unsuccessful." do 
      if user = User.find_by(parsed_response)
        render json: user, status: 200
      else
        user = User.create!(parsed_response)
        render json: user, status: 201
      end
    end
  end

  def show
    safe_query status:404 do
      user = User.find(params[:id])
      render status: 200, json: user
    end
  end
end
