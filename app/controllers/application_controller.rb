class ApplicationController < ActionController::API
  before_action :authenticate_request

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::ParameterMissing, with: :render_bad_request

  private
  attr_reader :current_user

  def authenticate_request
    token = bearer_token
    return render_unauthorized('Missing Authorization header') unless token

    payload = decode_token(token)
    return render_unauthorized('Invalid token') unless payload && payload['user_id']

    @current_user = User.find_by(id: payload['user_id'], auth_token: token)
    return render_unauthorized('Invalid credentials') unless @current_user
  end

  def authorize!(allowed, message = 'Forbidden')
    return true if allowed
    render_forbidden(message)
    false
  end

  def bearer_token
    header = request.headers['Authorization'].to_s
    match = header.match(/\ABearer\s+(.+)\z/i)
    match && match[1]
  end

  def decode_token(token)
    JWT.decode(
      token,
      JwtService.secret,
      true,
      algorithm: 'HS256',
      verify_expiration: true
    )[0]
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end

  def render_unauthorized(message = 'Unauthorized')
    render json: { error: message }, status: :unauthorized
  end

  def render_forbidden(message = 'Forbidden')
    render json: { error: message }, status: :forbidden
  end

  def render_not_found(exception = nil)
    render json: { error: 'Record not found' }, status: :not_found
  end

  def render_unprocessable(message)
    render json: { error: message }, status: :unprocessable_entity
  end

  def render_bad_request(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
