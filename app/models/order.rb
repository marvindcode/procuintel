class Order < ApplicationRecord
  enum :status, { draft: 0, pending: 1, approved: 2, received: 3, canceled: 4 }

  belongs_to :user,   optional: true          
  belongs_to :vendor                          
  has_many   :order_lines, dependent: :destroy
  has_many   :parts, through: :order_lines

  accepts_nested_attributes_for :order_lines, allow_destroy: true

  validates :vendor_id, presence: true
  validates :purchase_number, presence: true, uniqueness: true
  validates :order_total, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def recalc_total!
    update!(order_total: order_lines.sum("quantity * price"))
  end
end
