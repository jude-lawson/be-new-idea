class Api::V1::UsersController < ApplicationController
  def create
    begin
      user_data = JSON.parse(request.body.string)
      User.create!(user_data)
      render status: 204
    rescue StandardError => err
      feedback = {
        message: 'An error has occurred. User creation was unsuccessful.',
        error: "#{err.class}: #{err}"
      }
      render status: 400, json: feedback
    end
  end

  def show
    begin
      user = User.find(params[:id])
      render status: 200, json: user
    rescue StandardError => err
      feedback = {
        message: 'An error has occurred.',
        error: "#{err.class}: #{err}"
      }
      render status: 404, json: feedback
    end
  end
end
