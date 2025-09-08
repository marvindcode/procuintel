class Uom < ApplicationRecord
  has_many :parts
  has_many :order_lines
  has_many :inventories
  has_many :vendor_part_numbers

  validates :code, presence: true, uniqueness: true
end
