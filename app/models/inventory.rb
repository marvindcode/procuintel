class Inventory < ApplicationRecord
  belongs_to :warehouse
  belongs_to :part
  belongs_to :uom, optional: true

  validates :quantity, numericality: true
  validates :safe_inventory, numericality: true, allow_nil: true
  validates :value, numericality: true, allow_nil: true 
end
