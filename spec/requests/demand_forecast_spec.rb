require "rails_helper"
RSpec.describe "DemandForecasts", type: :request do
  it "GET /demand_forecasts is OK" do
    get "/demand_forecasts"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Demand Forecasts")
  end
end
