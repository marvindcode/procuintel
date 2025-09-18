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

describe "POST /parts" do
    it "creates a part with valid params" do
      post parts_path, params: {
        part: {
          part_number: "ZX00005",
          name: "Part",
          is_active: true,
          unit_of_measure: "EA", 
          value: 2.50
        }
      }
      expect(response).to redirect_to(Part.last)
      follow_redirect!
      expect(response.body).to include("Part created")
      expect(Part.last.part_number).to eq("ZX00005")
      expect(Part.last.name).to eq("Part")
    end

    it "fails with invalid params" do
      post parts_path, params: { part: { part_number: "", name: "", is_active: true } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("error").or include("errors")
    end
  end

  describe "PUT /parts/:id" do
    it "updates a part" do
      part = Part.create!(part_number: "OLD", name: "Old Name", is_active: true, unit_of_measure: "EA", value: 1.0)
      put part_path(part), params: { part: { part_number: "NEW-123", name: "New Name" } }
      expect(response).to redirect_to(part)
      expect(part.reload.part_number).to eq("NEW-123")
      expect(part.reload.name).to eq("New Name")
    end

    it "returns unprocessable when invalid" do
      part = Part.create!(part_number: "KEEP", name: "Valid", is_active: true, unit_of_measure: "EA")
      put part_path(part), params: { part: { part_number: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end