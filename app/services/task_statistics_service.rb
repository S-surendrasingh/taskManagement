class TaskStatisticsService
  def initialize(user)
    @user = user
  end

  def call
    base = Task.where(user_id: @user.id)
    status_counts = base.group(:status).count

    completed = status_counts['completed'].to_i
    pending = status_counts['pending'].to_i
    total = completed + pending
    overdue = base.where(status: 'pending').where('due_date < ?', Time.current).count

    {
      total_tasks: total,
      completed_tasks: completed,
      pending_tasks: pending,
      overdue_tasks: overdue
    }
  end
end
