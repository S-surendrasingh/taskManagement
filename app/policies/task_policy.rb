class TaskPolicy
  attr_reader :user, :task

  def initialize(user, task)
    @user = user
    @task = task
  end

  def view?
    admin? || owns_task?
  end

  def update?
    admin? || owns_task?
  end

  def delete?
    admin?
  end

  class Scope
    def initialize(user, scope = Task.all)
      @user = user
      @scope = scope
    end

    def resolve
      return @scope if @user.admin?
      @scope.where(user_id: @user.id)
    end
  end

  private

  def admin?
    user&.admin?
  end

  def owns_task?
    task.user_id == user.id
  end
end
