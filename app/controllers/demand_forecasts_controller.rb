class DemandForecastsController < ApplicationController
  def index
    @forecasts = DemandForecast.includes(:part, :warehouse).order(forecast_date: :desc)
  end
end