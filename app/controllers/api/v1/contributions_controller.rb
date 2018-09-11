class Api::V1::ContributionsController < ApplicationController
  def create
    body = JSON.parse(request.body.string)

    begin
      idea = Idea.find(params[:id])
      idea.contributions.create!(body)
      render status: 201
    rescue StandardError => err
      feedback = {
        message: 'An error has occurred.',
        error: "#{err.class}: #{err}"
      }

      render status: 400, json: feedback
    end
  end

  def edit
    body = JSON.parse(request.body.string)

    begin
      Contribution.find(params[:id]).update(body)
      render status: 201
    rescue StandardError => err
      feedback = {
        message: 'An error has occurred',
        error: "#{err.class}: #{err}"
      }

      render status: 400, json: feedback
    end
  end
end
