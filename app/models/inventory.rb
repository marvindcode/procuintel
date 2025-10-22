class Inventory < ApplicationRecord
  belongs_to :warehouse
  belongs_to :part
  belongs_to :uom, optional: true

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :safe_inventory, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :low_stock, -> { where("safe_inventory IS NOT NULL AND quantity <= safe_inventory") }

  def low_stock?
    safe_inventory.present? && quantity.to_i <= safe_inventory.to_i
  end

  def reorder_qty(buffer: 0)
    return 0 unless low_stock?
    [safe_inventory - quantity + buffer, 0].max
  end
end
