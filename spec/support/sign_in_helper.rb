module SignInHelper
  def sign_in_as(user)
    post "/sessions", params: { username: user.username, password: user.password || 'secret123' }  # Adjust password
  end
end