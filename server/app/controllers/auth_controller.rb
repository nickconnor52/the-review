class AuthController < ApplicationController
  before_action :get_user, only: [:login]

  def login
    if @user && @user.authenticate(params[:password])
      payload = { user_id: @user.to_param }
      token = encode_token(payload)
      serialized_user = {
        first_name: @user.first_name,
        last_name: @user.last_name,
        username: @user.username,
        email: @user.email,
        role: @user.role,
        id: @user.to_param,
        team: @user.team
      }
      render :json => { user: serialized_user, jwt: token, success: 'Welcome back, chump' }
    else
      render :json => { errors: 'Email or Password incorrect' }
    end
  end

  def auto_login
    if session_user
      render :json => session_user
    else
      render :json => { errors: 'No User signed in'}
    end
  end


  private

  def get_user
    @user = User.find_by(email: params[:email])
  end
end
