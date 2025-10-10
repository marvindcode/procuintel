class OrderLine < ApplicationRecord
  belongs_to :order
  belongs_to :part
  belongs_to :uom, optional: true

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }, presence: true
  validates :price,    numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :order_id, presence: true
  validates :part_id,  presence: true

  after_save :recalc_order_total
  after_destroy :recalc_order_total

  private
  def recalc_order_total
    order.recalc_total!
  end

end
