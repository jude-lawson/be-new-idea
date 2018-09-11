class Api::V1::IdeasController < ApplicationController
  def show

    begin
      idea = Idea.find_by(id:params['id']) 
      if idea
        render json: idea, status: 200, serializer: IdeaSerializer
      else
        error = "Idea not found"
        render json: {error:error}, status:404
      end

    rescue StandardError => err
      feedback = {
        message: 'An error has occurred.',
        error: "#{err.class}: #{err}"
      }
      render status: 400, json: feedback
    end

  end
  
  def index
    @ideas = Idea.all_with(params.as_json)
    render json: @ideas, status: 200, each_serializer: MultipleIdeasSerializer
  end
end
