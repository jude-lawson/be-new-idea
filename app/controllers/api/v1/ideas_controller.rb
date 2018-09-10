class Api::V1::IdeasController < ApplicationController
  def index
    @ideas = Idea.all_with(params.as_json)
    render json: @ideas, status: 200, each_serializer: MultipleIdeasSerializer
  end
end
