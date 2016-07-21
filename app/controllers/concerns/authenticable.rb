module Authenticable

  # Devise methods overwrites
  def current_user
    @current_user ||= User.find_by(token: request.headers['Authorization'])
  end
end
