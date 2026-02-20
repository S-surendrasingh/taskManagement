module Admin
  class BaseController < ActionController::Base
    layout 'admin'
    before_action :require_admin!
    helper_method :current_admin

    private

    def current_admin
      return @current_admin if defined?(@current_admin)
      @current_admin = User.find_by(id: session[:admin_user_id], role: 'admin')
    end

    def require_admin!
      return if current_admin
      redirect_to admin_login_path, alert: 'Please sign in as admin.'
    end
  end
end
