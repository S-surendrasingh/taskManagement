class Task < ApplicationRecord
  belongs_to :user

  enum status: { pending: 'pending', completed: 'completed' }

  validates :title, presence: true
  validates :status, inclusion: { in: statuses.keys }

  after_commit :bump_tasks_cache_version

  private

  def bump_tasks_cache_version
    user_ids = [user_id]
    if saved_change_to_user_id?
      user_ids << saved_change_to_user_id.first
    end

    user_ids.compact.uniq.each do |id|
      TasksCache.bump_user!(id)
    end

    TasksCache.bump_admin!
  end
end
