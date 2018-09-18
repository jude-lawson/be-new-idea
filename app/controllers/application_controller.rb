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

  def gateway
    begin
      provided_auth = JwtService.decode(request.headers['Authorization'])[0]
      user_access_token = User.find_by(uid: provided_auth['uid']).access_token

      if user_access_token == provided_auth['access_token']
        safe_query do
          yield
        end
      else
        render status: 401, json: { message: 'Bad Authentication' }
      end
    rescue JWT::DecodeError
      render status: 401, json: { message: 'Authorization header was not provided or is mis-structured.'}
    end
  end
end
