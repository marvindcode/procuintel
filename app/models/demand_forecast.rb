class DemandForecast < ApplicationRecord
  belongs_to :part
  belongs_to :warehouse

  validates :forecast_date, presence: true
  validates :forecast_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
