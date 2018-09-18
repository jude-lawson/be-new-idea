class Api::V1::ContributionsController < ApplicationController
  def create
    gateway status: 400 do
      idea = Idea.find(params[:id])
      idea.contributions.create!(parsed_response)
      render status: 201
    end
  end

  def edit
    safe_query status: 400 do
      Contribution.find(params[:id]).update(parsed_response)
      render status: 201
    end
  end
end
