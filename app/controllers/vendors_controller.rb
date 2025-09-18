class VendorsController < ApplicationController
  before_action :set_vendor, only: [:show, :edit, :update]
  before_action :preload,    only: [:new, :edit, :create, :update]

  def index
    @vendors = Vendor
      .left_joins(:vendor_part_numbers)
      .select("vendors.*, COUNT(vendor_part_numbers.id) AS items_count")
      .group("vendors.id")
      .order(:name)
  end

  def show
    @items = @vendor.vendor_part_numbers.includes(:part, :uom)
    @lead_times = @vendor.vendor_lead_times.includes(:part) if @vendor.respond_to?(:vendor_lead_times)
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(vendor_params)
    if @vendor.save
      redirect_to @vendor, notice: "Vendor created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @vendor.update(vendor_params)
      redirect_to @vendor, notice: "Vendor updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_vendor
    @vendor = Vendor.find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(
      :name,
      :email,
      :phone,
      :payment_terms, 
      :status,      
      :notes         
    )
  end
end
