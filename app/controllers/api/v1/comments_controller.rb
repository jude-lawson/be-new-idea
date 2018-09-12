class Api::V1::CommentsController < ApplicationController
  def edit
    begin
      Comment.find(params[:id]).update(parsed_response)
      render status: 201
    rescue StandardError => err
      feedback = {
        message: 'An error has occurred',
        error: "#{err.class}: #{err}"
      }
      render status: 400, json: feedback
    end
  end
  
  def create
    begin
      contribution = Contribution.find(params[:id])
      contribution.comments.create!(parsed_response)
      render status: 201
    rescue StandardError => err
      feedback = {
        message: 'An error has occurred.',
        error: "#{err.class}: #{err}"
      }
      render status: 400, json: feedback
    end
  end
end
