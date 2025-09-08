class DashboardController < ApplicationController
  def show
    @total_inventory_value = Inventory.sum(:value) 
    @open_pos = Order.where(status: [:pending, :approved]).count
    @low_stock = Inventory
      .select("inventories.*, (safe_inventory - quantity) AS gap")
      .includes(:part, :warehouse)
      .where("quantity < safe_inventory")
      .order("gap DESC")
      .limit(10)
  end
end
