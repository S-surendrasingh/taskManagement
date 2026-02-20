module JwtService
  def self.secret
    ENV['JWT_SECRET'] || Rails.application.credentials.secret_key_base || 'please_change_me'
  end

  def self.issue_token(payload)
    payload = payload.merge({ exp: 7.days.from_now.to_i })
    JWT.encode(payload, secret, 'HS256')
  end
end
