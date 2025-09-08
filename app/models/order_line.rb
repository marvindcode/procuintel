class OrderLine < ApplicationRecord
  belongs_to :order
  belongs_to :part
  belongs_to :uom, optional: true

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price,    numericality: { greater_than_or_equal_to: 0 }

  validates :order_id, presence: true
  validates :part_id,  presence: true
end
