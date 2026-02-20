module Admin
  class SessionsController < ActionController::Base
    layout 'admin'

    def new
    end

    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password]) && user.admin?
        session[:admin_user_id] = user.id
        redirect_to admin_tasks_path, notice: 'Signed in as admin.'
      else
        flash.now[:alert] = 'Invalid credentials or not an admin.'
        render :new, status: :unauthorized
      end
    end

    def destroy
      session.delete(:admin_user_id)
      redirect_to admin_login_path, notice: 'Signed out.'
    end
  end
end
