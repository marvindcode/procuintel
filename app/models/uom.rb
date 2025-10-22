class Uom < ApplicationRecord
  has_many :parts
  has_many :order_lines
  has_many :inventories
end
