class DemandForecastsController < ApplicationController
  skip_before_action :require_login, only: :index

  def index
    @forecasts = DemandForecast.all
    render :index, status: :ok
  end
end
