class CoffeeController < ApplicationController
  def brew
    render json: {message: "I'm a Teapot!"}, status: 418
  end
end
