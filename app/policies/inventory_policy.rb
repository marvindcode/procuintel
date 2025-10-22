class InventoryPolicy < ApplicationPolicy
  def index?
    user.present? && %w[admin viewer].include?(user.role)
  end

  def show?
    index?  
  end

  def create?
    user.present? && user.role == 'admin'
  end

  def update?
    user.present? && user.role == 'admin'
  end

end