class Api::V1::CoffeeController < ApplicationController
  def brew
    safe_query do
      bev = params['beverage']
      case bev
      when 'tea'
        render json: {message: "Here's some tea"}, status: 200
      else
        render json: {message: "I'm a Teapot!"}, status: 418 
      end
    end
  end
end
