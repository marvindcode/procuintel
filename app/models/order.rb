class Order < ApplicationRecord
  belongs_to :vendor
  belongs_to :user, foreign_key: :buyer_id
  has_many :order_lines, dependent: :destroy
  accepts_nested_attributes_for :order_lines, allow_destroy: true
  before_save :calculate_total 

  private
  def calculate_total
    self.order_total = order_lines.sum { |ol| ol.quantity * ol.price }
  end
end