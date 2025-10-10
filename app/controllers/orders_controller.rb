class OrdersController < ApplicationController
  before_action :require_login
  before_action :set_order, only: %i[show update]

  def index
    @orders = Order.includes(:vendor, :order_lines).order(created_at: :desc)
  end

  def show; end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to @order
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @order.update(order_params)
      redirect_to @order
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(
      :purchase_number, :vendor_id,
      order_lines_attributes: %i[id part_id quantity _destroy]
    )
  end
end

