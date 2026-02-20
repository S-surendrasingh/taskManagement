class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy

  enum role: { user: 'user', admin: 'admin' }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :auth_token, uniqueness: true, allow_nil: true

  before_validation :ensure_role
  before_validation :normalize_email

  private

  def ensure_role
    self.role ||= 'user'
  end

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
