class ApplicationController < ActionController::API
  def parsed_response
    JSON.parse(request.body.string)
  end
end
