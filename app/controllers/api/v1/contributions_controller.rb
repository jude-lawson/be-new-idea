class Api::V1::ContributionsController < ApplicationController
  def create
    body = JSON.parse(request.body.string)

    safe_query status: 400 do
      idea = Idea.find(params[:id])
      idea.contributions.create!(body)
      render status: 201
    end
  end

  def edit
    body = JSON.parse(request.body.string)

    safe_query status: 400 do
      Contribution.find(params[:id]).update(body)
      render status: 201
    end
  end
end
