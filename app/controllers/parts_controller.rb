class PartsController < ApplicationController
  before_action :set_part, only: [:show, :edit, :update]
  before_action :preload,  only: [:new, :edit, :create, :update]

  def index
    @parts = Part
      .left_joins(:vendor_part_numbers)
      .select("parts.*, COUNT(vendor_part_numbers.id) AS vendors_count")
      .group("parts.id")
      .order(:part_number)
  end

  def show
    @inventories      = @part.inventories.includes(:warehouse)
    @vendor_items     = @part.vendor_part_numbers.includes(:vendor, :uom)
    @recent_forecasts = @part.demand_forecasts
                             .where("forecast_date >= ?", 30.days.ago)
                             .includes(:warehouse)
                             .order(forecast_date: :desc)
    @lead_times = @part.vendor_lead_times.includes(:vendor) if @part.respond_to?(:vendor_lead_times)
  end

  def new
    @part = Part.new(is_active: true)
  end

  def create
    @part = Part.new(part_params)
    if @part.save
      redirect_to @part, notice: "Part created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @part.update(part_params)
      redirect_to @part, notice: "Part updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_part
    @part = Part.find(params[:id])
  end

  def preload
    @uoms       = Uom.order(:name)      if defined?(Uom)
    @warehouses = Warehouse.order(:name) if defined?(Warehouse)
    @vendors    = Vendor.order(:name)    if defined?(Vendor)
  end

  def part_params
    params.require(:part).permit(
      :part_number,
      :name,
      :description,
      :is_active,
      :value,                
      :uom_id,               
      :unit_of_measure       
    )
  end
end
