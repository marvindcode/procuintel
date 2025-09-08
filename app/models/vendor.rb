class Vendor < ApplicationRecord
  has_many :vendor_part_numbers, dependent: :destroy
  has_many :parts, through: :vendor_part_numbers
  has_many :vendor_lead_times, dependent: :destroy

  validates :name, presence: true
  validates :vendor_number, uniqueness: true, allow_nil: true
end
