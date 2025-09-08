class VendorsController < ApplicationController
  def index
    @vendors = Vendor.left_joins(:vendor_part_numbers)
                     .select("vendors.*, COUNT(vendor_part_numbers.id) AS items_count")
                     .group("vendors.id")
                     .order(:name)
  end

  def show
    @vendor = Vendor.find(params[:id])
    @items  = @vendor.vendor_part_numbers.includes(:part, :uom)
    @lead_times = @vendor.vendor_lead_times.includes(:part)
  end
end