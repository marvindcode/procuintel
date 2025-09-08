require "rails_helper"

RSpec.describe "Parts", type: :request do
  it "GET /parts is OK" do
    get "/parts"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Parts")
  end

  it "GET /parts/:id is OK" do
    part = Part.first || Part.create!(part_number: "P-1", name: "Test Part")
    get "/parts/#{part.id}"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(part.part_number)
  end
end

