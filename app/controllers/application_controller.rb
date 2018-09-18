class ApplicationController < ActionController::API
  def safe_query(error_params ={})
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

  def decode_auth
    begin
      JwtService.decode(request.headers['Authorization'])[0]
    rescue StandardError => err
      render status: 
    end
  end

  def gateway
    # provided_auth = JwtService.decode(request.headers['Authorization'])[0]
    provided_token = provided_auth['access_token']
    user_access_token = User.find_by(uid: provided_auth['uid']).access_token

    if user_access_token == provided_token
      safe_query do
        yield
      end
    else
      render status: 403, json: { message: 'Bad Authentication' }
    end
  end
end
