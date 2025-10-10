class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  skip_before_action :authenticate_user!, only: [:new, :create] if defined?(Devise)

  def new
    Rails.logger.debug "Reached UsersController#new"
    @user = User.new
  end

  def create
    Rails.logger.debug "Reached UsersController#create"
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "User created successfully"
    else
      Rails.logger.debug "User errors: #{@user.errors.full_messages}"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :role)
  end
end