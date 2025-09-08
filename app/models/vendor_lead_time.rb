class VendorLeadTime < ApplicationRecord
  belongs_to :vendor
  belongs_to :part

  validates :expected_lead_time, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :actual_lead_time,   numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

end
