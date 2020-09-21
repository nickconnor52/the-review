class ApplicationController < ActionController::API
  def encode_token(payload)
    JWT.encode(payload, 'secret')
  end

  def require_login
    render :json => { message: 'Please login' }, status: :unauthorized unless logged_in?
  end

  def session_user
    decoded_hash = decoded_token
    if !decoded_hash.nil? && !decoded_hash.empty?
      user_id = decoded_hash[0]['user_id']
      @user = User.find(user_id)
      serialized_user = {
        first_name: @user.first_name,
        last_name: @user.last_name,
        username: @user.username,
        email: @user.email,
        role: @user.role,
        team: @user.team,
      }

      serialized_user
    else
      nil
    end
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, 'secret', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        []
      end
    end
  end

  private

  def logged_in?
    !!session_user
  end

end
