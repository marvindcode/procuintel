class SessionsController < ApplicationController
  include Devise::Controllers::Helpers
  skip_before_action :authenticate_user!, only: [:new, :create]  # ← important

  def new
   
    redirect_to root_path, notice: "You're already signed in." and return if user_signed_in?
  end

  def create
    user = User.find_by(username: params[:username])
    if user&.valid_password?(params[:password])
      sign_in(user)
      redirect_to root_path, notice: "Logged in successfully!"
    else
      flash.now[:alert] = "Invalid username or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out(current_user) if current_user
    redirect_to root_path, notice: "Logged out!"
  end
end
