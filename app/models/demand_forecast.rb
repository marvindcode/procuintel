class DemandForecast < ApplicationRecord
  belongs_to :part
  belongs_to :warehouse

  def period
    forecast_date
  end
end