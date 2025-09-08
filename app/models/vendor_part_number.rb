class VendorPartNumber < ApplicationRecord
  belongs_to :vendor
  belongs_to :part
  belongs_to :uom, optional: true

  validates :vendor_item, presence: true
  validates :price,       numericality: { greater_than_or_equal_to: 0 }
  validates :lead_time,   numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  validates :is_active,   inclusion: { in: [true, false] }, if: -> { self.has_attribute?(:is_active) }

  validates :part_id, uniqueness: { scope: :vendor_id, message: "already has this vendor mapping" }
end

