class Part < ApplicationRecord
  belongs_to :uom, optional: true
  has_many :inventories, dependent: :destroy
  has_many :vendor_part_numbers, dependent: :destroy
  has_many :vendors, through: :vendor_part_numbers

  has_many :demand_forecasts, dependent: :destroy

  validates :part_number, presence: true, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :lead_time, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end