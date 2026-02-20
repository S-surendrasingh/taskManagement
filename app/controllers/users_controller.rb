class UsersController < ApplicationController
  before_action :set_user

  def task_stats
    return render_forbidden unless current_user.admin? || current_user.id == @user.id

    stats = TaskStatisticsService.new(@user).call
    render json: stats
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
