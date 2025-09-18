class Part < ApplicationRecord

  belongs_to :uom, optional: true                
  has_many :order_lines, dependent: :restrict_with_error
  has_many :orders, through: :order_lines

  has_many :inventories, dependent: :destroy
  has_many :warehouses,  through: :inventories

  has_many :vendor_part_numbers, dependent: :destroy
  has_many :vendors, through: :vendor_part_numbers

  has_many :vendor_lead_times, dependent: :destroy
  has_many :demand_forecasts,  dependent: :destroy

  before_validation :normalize_part_number

  validates :part_number, presence: true, uniqueness: { case_sensitive: false }
  validates :name,        presence: true
  validates :is_active,   inclusion: { in: [true, false] }

  validates :unit_of_measure, presence: true, unless: :uom_id?

  validates :value, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  private

  def normalize_part_number
    self.part_number = part_number.to_s.strip.upcase
  end
end
