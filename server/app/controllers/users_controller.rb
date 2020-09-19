class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    user.role = 'user'
    if user.save
      payload = { user_id: user.to_param }
      token = encode_token(payload)
      render :json => { user: user, jwt: token }
    else
      render :json => { errors: user.errors.full_messages }, status: :not_acceptable
    end

  end

  private
  def user_params
    params.permit(:username, :email, :password, :first_name, :last_name)
  end
end
