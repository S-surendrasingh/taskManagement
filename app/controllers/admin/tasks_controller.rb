module Admin
  class TasksController < Admin::BaseController
    before_action :set_task, only: [:show, :edit, :update, :destroy]
    before_action :load_users, only: [:new, :edit]

    def index
      @tasks = Task.includes(:user).order(created_at: :desc).limit(100)
    end

    def show
    end

    def new
      @task = Task.new
    end

    def create
      @task = Task.new(task_params)
      if @task.save
        redirect_to admin_tasks_path, notice: 'Task created.'
      else
        load_users
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @task.update(task_params)
        redirect_to admin_tasks_path, notice: 'Task updated.'
      else
        load_users
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @task.destroy
      redirect_to admin_tasks_path, notice: 'Task deleted.'
    end

    private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :status, :due_date, :user_id)
    end

    def load_users
      @users = User.order(:name)
    end
  end
end
