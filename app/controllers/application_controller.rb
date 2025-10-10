class ApplicationController < ActionController::Base
  helper_method :current_user_role
  before_action :require_login
  before_action :authenticate_user!

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
    Rails.logger.debug "Current user: #{@current_user.inspect}, Session: #{session[:user_id].inspect}"
    @current_user
  end

  def current_user_role
    current_user&.role 
  end

  private

  def require_login
    Rails.logger.debug "require_login called - Rails.env: #{Rails.env}, Test?: #{Rails.env.test?}, Controller: #{controller_name}, Action: #{action_name}, Controller Name Included: #{ %w[users sessions].include?(controller_name) }"
    if Rails.env.test?
      Rails.logger.debug "Skipping due to test environment"
      return
    end
    if current_user.present?
      Rails.logger.debug "Skipping due to current_user present"
      return
    end
    if %w[users sessions].include?(controller_name)
      Rails.logger.debug "Skipping due to controller_name: #{controller_name}"
      return
    end
    Rails.logger.debug "Rendering 403: login required"
    render plain: "login required", status: :forbidden
  end
end