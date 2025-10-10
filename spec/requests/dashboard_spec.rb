require "rails_helper"

RSpec.describe "Dashboard", type: :request do
  let!(:user) { create(:user, role: "viewer") }
  before { sign_in_as(user) }

  it "GET /dashboard is OK" do
    get "/dashboard"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Procuintel Dashboard")
    puts response.body 
  end
end