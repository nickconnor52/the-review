class UsersController < ApplicationController
  before_action :require_login, only: [:update]

  def create
    user = User.new(user_params)
    user.role = 'user'
    if user.save
      payload = { user_id: user.to_param }
      token = encode_token(payload)
      serialized_user = {
        first_name: user.first_name,
        last_name: user.last_name,
        username: user.username,
        email: user.email,
        role: user.role,
        id: user.to_param,
        team: user.team
      }
      render :json => { user: serialized_user, jwt: token }
    else
      render :json => { errors: user.errors.full_messages }, status: :not_acceptable
    end
  end

  def update
    @user.username = params[:username]
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.email = params[:email]

    if params[:password].present?
      @user.password = params[:password]
    end

    @user.save!

    serialized_user = {
      first_name: @user.first_name,
      last_name: @user.last_name,
      username: @user.username,
      email: @user.email,
      role: @user.role,
      id: @user.to_param,
      team: @user.team
    }

    render :json => serialized_user
  end

  private
  def get_user
    @user = User.find(params[:id])
  end
  def user_params
    params.permit(:username, :email, :password, :first_name, :last_name)
  end
end
