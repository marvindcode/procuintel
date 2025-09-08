require "rails_helper"
RSpec.describe "Vendors", type: :request do
  it "GET /vendors is OK" do
    get "/vendors"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Vendors")
  end

  it "GET /vendors/:id is OK" do
    vendor = Vendor.first || Vendor.create!(name: "VendorCo")
    get "/vendors/#{vendor.id}"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(vendor.name)
  end
end
