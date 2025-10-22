class Vendor < ApplicationRecord
  has_many :vendor_part_numbers, dependent: :destroy
  has_many :parts, through: :vendor_part_numbers

  validates :name, presence: true
end



