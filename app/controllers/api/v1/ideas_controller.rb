class Api::V1::IdeasController < ApplicationController
  def show
    safe_query do
      idea = Idea.find_by(id:params['id']) 
      if idea
        render json: idea, status: 200, serializer: IdeaSerializer
      else
        error = "Idea not found"
        render json: {error:error}, status:404
      end
    end
  end
  
  def index
    @ideas = Idea.all_with(params.as_json)
    render json: @ideas, status: 200, each_serializer: MultipleIdeasSerializer
  end
end
