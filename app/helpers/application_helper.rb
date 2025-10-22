module ApplicationHelper
  def needs_reorder?(inventory, forecast)
    inventory.quantity < inventory.safe_inventory || forecast.forecasted_usage > inventory.quantity
  end
end