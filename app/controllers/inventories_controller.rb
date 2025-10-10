class InventoriesController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  before_action :set_inventory, only: %i[show edit update]
  before_action :preload,       only: %i[new create edit update]

  def index
    @inventories = Inventory
      .joins(:warehouse, :part)
      .includes(:warehouse, :part, :uom)
      .order("warehouses.name ASC, parts.part_number ASC")
  end

  def show; end

  def create
    @inventory = Inventory.new(inventory_params)
    if @inventory.save
      redirect_to @inventory, notice: "Inventory record created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @inventory.update(inventory_params)
      redirect_to @inventory, notice: "Inventory updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_inventory
    @inventory = Inventory.includes(:warehouse, :part, :uom).find(params[:id])
  end

  def preload
    @warehouses = Warehouse.order(:name)
    @parts      = Part.order(:part_number)
    @uoms       = Uom.order(:name) if defined?(Uom)
  end

  def inventory_params
    params.require(:inventory).permit(:warehouse_id, :part_id, :quantity, :safe_inventory, :value, :uom_id, :unit_of_measure)
  end
end
