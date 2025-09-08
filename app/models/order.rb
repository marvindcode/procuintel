class Order < ApplicationRecord
  enum :status, { draft: 0, pending: 1, approved: 2, received: 3, canceled: 4 }  # ← change this too

  belongs_to :user
  has_many :order_lines, dependent: :destroy
  has_many :parts, through: :order_lines

  validates :purchase_number, presence: true, uniqueness: true
  validates :order_total, numericality: { greater_than_or_equal_to: 0 }

  def recalc_total!
    update!(order_total: order_lines.sum('quantity * price'))
  end
end
