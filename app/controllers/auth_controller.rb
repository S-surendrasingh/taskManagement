class AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [:signup, :login]

  def signup
    user = User.new(signup_params)
    user.role = 'user'
    if user.save
      token = JwtService.issue_token(user_id: user.id)
      if user.update(auth_token: token)
        render json: { auth_token: token }, status: :created
      else
        render_unprocessable(user.errors.full_messages.join(', '))
      end
    else
      render_unprocessable(user.errors.full_messages.join(', '))
    end
  end

  def login
    user = User.find_by(email: login_params[:email].to_s.downcase)
    if user&.authenticate(login_params[:password])
      token = JwtService.issue_token(user_id: user.id)
      if user.update(auth_token: token)
        render json: { auth_token: token }
      else
        render_unprocessable(user.errors.full_messages.join(', '))
      end
    else
      render_unauthorized('Invalid email or password')
    end
  end

  private

  def signup_params
    params.permit(:name, :email, :password)
  end

  def login_params
    params.permit(:email, :password)
  end
end
