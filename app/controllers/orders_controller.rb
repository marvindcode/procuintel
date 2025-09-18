class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update]
  before_action :preload,   only: [:new, :create, :edit, :update]

  def index
    @orders = Order
      .includes(:user, :vendor) 
      .order(created_at: :desc)
  end

  def show
    
  end


  def new
    @order = Order.new(vendor_id: params[:vendor_id])
    3.times { @order.order_lines.build } 
  end

  def create
    @order = Order.new(order_params)
  
      @order.user = current_user

    if @order.save
      @order.recalc_total! if @order.respond_to?(:recalc_total!)
      redirect_to @order, notice: "PO created."
    else
      render :new, status: :unprocessable_entity
    end
  end


  def edit; end

  def update
    if @order.update(order_params)
      @order.recalc_total! if @order.respond_to?(:recalc_total!)
      redirect_to @order, notice: "PO updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order
      .includes(order_lines: [:part, :uom]) 
      .find(params[:id])
  end

  def preload
    @vendors = Vendor.order(:name)
    @parts   = Part.order(:part_number)
    @uoms    = Uom.order(:name) if defined?(Uom)
  end

  def order_params
    params.require(:order).permit(
      :vendor_id,
      :purchase_number,  
      :order_date,
      :expected_date,
      :status,
      :notes,
      order_lines_attributes: [
        :id,
        :part_id,
        :quantity,
        :price,
        :uom_id,           
        :unit_of_measure,  
        :_destroy
      ]
    )
  end
end

