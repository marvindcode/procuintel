class PartsController < ApplicationController
  def index
    @parts = Part.left_joins(:vendor_part_numbers)
                 .select("parts.*, COUNT(vendor_part_numbers.id) AS vendors_count")
                 .group("parts.id")
                 .order(:part_number)
  end

  def show
    @part = Part.find(params[:id])

    @inventories      = @part.inventories.includes(:warehouse)
    @vendor_items     = @part.vendor_part_numbers.includes(:vendor, :uom)
    @recent_forecasts = @part.demand_forecasts
                             .where("forecast_date >= ?", 30.days.ago)
                             .includes(:warehouse)
                             .order(forecast_date: :desc)

    @lead_times = @part.vendor_lead_times.includes(:vendor) if @part.respond_to?(:vendor_lead_times)
  end
end
