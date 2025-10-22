class DemandForecastsController < ApplicationController
  def index
    @forecasts = DemandForecast.all 
    render :index 
  end
end