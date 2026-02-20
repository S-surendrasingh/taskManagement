class TasksController < ApplicationController
  include Pagination

  TASK_FIELDS = %i[id title description status due_date user_id].freeze
  USER_FIELDS = %i[id name email].freeze
  TASK_SELECT = TASK_FIELDS.map { |field| "tasks.#{field}" }.join(', ').freeze

  before_action :set_task, only: [:show, :update, :destroy]

  def index
    page, per_page = pagination_params

    json = TasksCache.fetch(current_user, page: page, per_page: per_page) do
      tasks = TaskPolicy::Scope.new(current_user).resolve
              .order(due_date: :asc)
              .offset((page - 1) * per_page)
              .limit(per_page)
              .includes(:user)
              .select(TASK_SELECT)

      serialize_tasks(tasks)
    end

    render json: json
  end

  def show
    policy = TaskPolicy.new(current_user, @task)
    return unless authorize!(policy.view?, 'You do not have access to this task')

    render json: serialize_task(@task)
  end

  def create
    task = Task.new(task_params)
    task.user = user_for_task
    if task.save
      render json: serialize_task(task), status: :created
    else
      render_unprocessable(task.errors.full_messages.join(', '))
    end
  end

  def update
    policy = TaskPolicy.new(current_user, @task)
    return unless authorize!(policy.update?, 'You cannot modify this task')

    if @task.update(task_params)
      render json: serialize_task(@task)
    else
      render_unprocessable(@task.errors.full_messages.join(', '))
    end
  end

  def destroy
    policy = TaskPolicy.new(current_user, @task)
    return unless authorize!(policy.delete?, 'You cannot delete this task')

    @task.destroy
    head :no_content
  end

  private

  def set_task
    @task = Task.includes(:user).select(TASK_SELECT).find(params[:id])
  end

  def task_params
    params.permit(:title, :description, :status, :due_date)
  end

  def user_for_task
    return current_user unless current_user.admin? && params[:user_id].present?
    User.find(params[:user_id])
  end

  def serialize_tasks(tasks)
    tasks.as_json(only: TASK_FIELDS, include: { user: { only: USER_FIELDS } })
  end

  def serialize_task(task)
    task.as_json(only: TASK_FIELDS, include: { user: { only: USER_FIELDS } })
  end
end
