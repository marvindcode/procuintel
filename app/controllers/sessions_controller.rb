class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    render :new, status: :ok
  end

  def create
  
    identifier = params[:username].presence || params[:email].presence
    user = User.find_by(username: identifier) || User.find_by(email: identifier)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in"
    else
      render :new, status: :unauthorized
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "Logged out"
  end
end

