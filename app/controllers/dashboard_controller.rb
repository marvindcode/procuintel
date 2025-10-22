class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @parts_count       = Part.count
    @vendors_count     = Vendor.count
    @warehouses_count  = Warehouse.count
    @inventories_count = Inventory.count
    @low_stock = Inventory.where("safe_inventory IS NOT NULL AND quantity <= safe_inventory")
                          .includes(:part, :warehouse).order(:warehouse_id, :part_id).limit(5)

    if Inventory.column_names.include?("safe_inventory")
      @low_stock = Inventory
        .where("quantity <= safe_inventory")
        .includes(:part, :warehouse)
        .order(:warehouse_id, :part_id)
        .limit(5)
    else
      @low_stock = Inventory
        .order(:warehouse_id, :part_id)
        .includes(:part, :warehouse)
        .limit(5)
    end


    @low_stock ||= []
  end
end


