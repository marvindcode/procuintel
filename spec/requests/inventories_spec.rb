require "rails_helper"

RSpec.describe "Inventories", type: :request do
  let!(:uom)  { Uom.first_or_create!(code: "EA") }
  let!(:wh)   { Warehouse.first_or_create!(name: "LA") }
  let!(:part) do
    Part.first || Part.create!(part_number: "P-1", name: "Test Part", uom: uom, is_active: true, price: 10.0)
  end

  context "authenticated viewer (read-only)" do
    let!(:user) { create(:user, role: "viewer") }
    before { sign_in_as(user) }

    it "GET /inventories is OK" do
      get "/inventories"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Inventories").or include("Inventory")
    end

    it "GET /inventories/:id is OK" do
      inv = Inventory.first || Inventory.create!(
        part: part, warehouse: wh, uom: uom,
        quantity: 1, safe_inventory: 2, inventory_value: 10
      )
      get "/inventories/#{inv.id}"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Inventory")
    end

    it "POST /inventories is forbidden for viewer" do
      post inventories_path, params: {
        inventory: {
          warehouse_id: wh.id,
          part_id: part.id,
          quantity: 100,
          safe_inventory: 20,
          uom_id: uom.id
        }
      }
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to include("admin only") # Adjust to your error message
    end

    it "PUT /inventories/:id is forbidden for viewer" do
      inv = Inventory.create!(warehouse: wh, part: part, uom: uom, quantity: 10, safe_inventory: 2)
      put inventory_path(inv), params: { inventory: { quantity: 25 } }
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to include("admin only")
    end
  end

  context "authenticated admin (full CRUD)" do
    let!(:user) { create(:user, role: "admin") }
    before { sign_in_as(user) }

    it "POST /inventories creates a new inventory record" do
      expect {
        post inventories_path, params: {
          inventory: {
            warehouse_id: wh.id,
            part_id: part.id,
            quantity: 100,
            safe_inventory: 20,
            uom_id: uom.id
          }
        }
      }.to change(Inventory, :count).by(1)
      expect(response).to have_http_status(:redirect)
      expect(Inventory.last.quantity).to eq(100)
    end

    it "PUT /inventories/:id updates inventory qty" do
      inv = Inventory.create!(warehouse: wh, part: part, uom: uom, quantity: 10, safe_inventory: 2)
      put inventory_path(inv), params: { inventory: { quantity: 25 } }
      expect(response).to have_http_status(:redirect)
      expect(inv.reload.quantity).to eq(25)
    end
  end
end