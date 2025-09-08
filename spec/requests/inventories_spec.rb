require "rails_helper"
RSpec.describe "Inventories", type: :request do
  it "GET /inventories is OK" do
    get "/inventories"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Inventories")
  end

  it "GET /inventories/:id is OK" do
    uom  = Uom.first_or_create!(code: "EA")
    wh   = Warehouse.first_or_create!(name: "LA")
    part = Part.first_or_create!(part_number: "P-1", name: "Test Part", uom: uom, is_active: true)

    inv = Inventory.first || Inventory.create!(
      part: part, warehouse: wh, uom: uom,
      quantity: 1, safe_inventory: 2, inventory_value: 10
    )

    get "/inventories/#{inv.id}"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Inventory #")
  end
end
