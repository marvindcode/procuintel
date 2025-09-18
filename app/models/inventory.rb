class Inventory < ApplicationRecord
  enum :status, { active: 0, inactive: 1 }

  alias_attribute :inventory_value, :value

  belongs_to :part
  belongs_to :warehouse
  belongs_to :uom, optional: true

  validates :quantity,        numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  validates :safe_inventory,  numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :inventory_value, numericality: { greater_than_or_equal_to: 0 }
end
