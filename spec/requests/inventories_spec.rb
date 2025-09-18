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

describe "POST /inventories" do
    it "creates a new inventory record" do
      params = {
        inventory: {
          warehouse_id: wh.id,
          part_id: part.id,
          quantity: 100,
          safe_inventory: 20
        }
      }
      if has_uom?
        params[:inventory][:uom_id] = uom.id
        params[:inventory][value_key] = 3.0
      else
        params[:inventory][:unit_of_measure] = "EA"
        params[:inventory][value_key] = 3.0
      end

      post inventories_path, params: params
      expect(response).to redirect_to(Inventory.last)
      expect(Inventory.last.quantity).to eq(100)
    end
  end

  describe "PUT /inventories/:id" do
    it "updates inventory qty" do
      inv_params = {
        warehouse_id: wh.id,
        part_id: part.id,
        quantity: 10
      }
      if has_uom?
        inv_params[:uom_id] = uom.id
        inv_params[value_key] = 3.0
      else
        inv_params[:unit_of_measure] = "EA"
        inv_params[value_key] = 3.0
      end

      inv = Inventory.create!(inv_params)

      put inventory_path(inv), params: { inventory: { quantity: 25 } }
      expect(response).to redirect_to(inv)
      expect(inv.reload.quantity).to eq(25)
    end
  end
end