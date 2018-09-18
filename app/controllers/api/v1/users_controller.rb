class Api::V1::UsersController < ApplicationController
  def create
    safe_query message:" User creation was unsuccessful." do
      result = User.create_with_token(parsed_response)

      if result[:db_memo] == 'found'
        render json: result[:user], status: 200
      elsif result[:db_memo] == 'created'
        response.set_header 'Authorization', JwtService.encode({ access_token: result[:token], uid: result[:user] })
        render json: result[:user], status: 201
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
