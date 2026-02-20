class TasksCache
  USER_VERSION_KEY = 'tasks:version:user:%{user_id}'
  ADMIN_VERSION_KEY = 'tasks:version:admin'

  def self.fetch(user, page:, per_page:, &block)
    Rails.cache.fetch(cache_key(user, page: page, per_page: per_page), &block)
  end

  def self.bump!(user_id:)
    bump_user!(user_id)
    bump_admin!
  end

  def self.bump_user!(user_id)
    Rails.cache.increment(user_version_key(user_id), 1, initial: 1)
  end

  def self.bump_admin!
    Rails.cache.increment(ADMIN_VERSION_KEY, 1, initial: 1)
  end

  def self.cache_key(user, page:, per_page:)
    version = user.admin? ? admin_version : user_version(user.id)
    prefix = user.admin? ? 'tasks:admin' : "tasks:user:#{user.id}"
    "#{prefix}:v#{version}:page=#{page}:per=#{per_page}"
  end

  def self.user_version(user_id)
    Rails.cache.fetch(user_version_key(user_id)) { 1 }
  end

  def self.admin_version
    Rails.cache.fetch(ADMIN_VERSION_KEY) { 1 }
  end

  def self.user_version_key(user_id)
    format(USER_VERSION_KEY, user_id: user_id)
  end

  private_class_method :user_version_key
end
