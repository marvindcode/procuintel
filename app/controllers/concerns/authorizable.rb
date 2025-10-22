module Authorizable
  extend ActiveSupport::Concern
  included do
    before_action :require_admin!, only: [:new, :create, :edit, :update, :destroy]
  end
  private
  def require_admin!
    return if current_user&.role == "admin"
    redirect_to request.referer.presence || root_path, alert: "Not authorized."
  end
end
