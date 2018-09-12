class Api::V1::CommentsController < ApplicationController
  def edit
    kant do
      Comment.find(params[:id]).update(parsed_response)
      render status: 201
    end
  end
  
  def create
    kant do
      contribution = Contribution.find(params[:id])
      contribution.comments.create!(parsed_response)
      render status: 201
    end
  end
end
