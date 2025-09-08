class InventoriesController < ApplicationController
  def index
    @inventories = Inventory.includes(:part, :warehouse, :uom)
                            .order("warehouses.name ASC, parts.part_number ASC")
  end

  def show
    @inventory = Inventory.includes(:part, :warehouse, :uom).find(params[:id])
  end
end
