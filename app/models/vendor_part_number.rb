class VendorPartNumber < ApplicationRecord
  belongs_to :vendor
  belongs_to :part
  validates :vendor_item, presence: true
  validates :vendor_id, :part_id, presence: true
end
