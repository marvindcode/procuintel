require "rails_helper"
RSpec.describe "Dashboard", type: :request do
  it "GET /dashboard is OK" do
    get "/dashboard"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Procuintel Dashboard")
  end
end
