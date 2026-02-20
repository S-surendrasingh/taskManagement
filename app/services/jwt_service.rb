class JwtService
  ALGORITHM = 'HS256'
  DEFAULT_TTL = 7.days

  def self.issue_token(payload, exp: DEFAULT_TTL.from_now)
    payload = payload.merge(exp: exp.to_i)
    JWT.encode(payload, secret, ALGORITHM)
  end

  def self.secret
    ENV.fetch('JWT_SECRET') { Rails.application.secret_key_base }
  end
end
