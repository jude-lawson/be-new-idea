class ApplicationController < ActionController::API
  def kant(error_params ={})
    status = error_params[:status] || 400

    begin 
      yield
    rescue StandardError => err
      feedback = error_params[:feedback] || {
        message: "An error has occurred.#{error_params[:message]}",
        error: "#{err.class}: #{err}"
      }
      render status: status, json: feedback
    end
  end

  def parsed_response
    JSON.parse(request.body.string)
  end
end
