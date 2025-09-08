class OrdersController < ApplicationController
  def index
    @orders = Order.order(created_at: :desc).includes(:user)
  end

  def show
    @order = Order.includes(order_lines: [ :part, :uom ]).find(params[:id])
  end
end
