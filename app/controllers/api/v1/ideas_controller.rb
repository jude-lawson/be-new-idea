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

  def edit
    safe_query do
      idea = Idea.find(params[:id])
      idea.update(parsed_response)
      render status: 201
    end
  end
  
  def create
    safe_query do
      user = User.find(parsed_response["user_id"])
      user.ideas.create!(parsed_response)
      render json: {message:"Idea successfully created"}, status:201
    end
  end
  
  def index
    @ideas = Idea.all_with(params.as_json)
    render json: @ideas, status: 200, each_serializer: MultipleIdeasSerializer
  end
end
