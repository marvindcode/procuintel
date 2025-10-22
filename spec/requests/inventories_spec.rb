require "rails_helper"

RSpec.describe "Inventories", type: :request do
  let!(:uom)  { Uom.first_or_create!(code: "EA") }
  let!(:wh)   { Warehouse.first_or_create!(name: "LA") }
  let!(:part) do
    Part.first || Part.create!(part_number: "P-1", name: "Test Part", uom: uom, is_active: true, price: 10.0)
  end

  describe "unauthenticated access" do
    it "GET /inventories returns 403" do
      get "/inventories"
      expect(response).to have_http_status(:forbidden)
    end

    it "GET /inventories/:id returns 403" do
      inv = Inventory.first || Inventory.create!(part_id: part.id, warehouse_id: wh.id, uom_id: uom.id, quantity: 1, safe_inventory: 2, unit_of_measure: "EA")
      get "/inventories/#{inv.id}"
      expect(response).to have_http_status(:forbidden)
    end

    it "POST /inventories returns 403" do
      post "/inventories", params: {
        inventory: {
          warehouse_id: wh.id,
          part_id: part.id,
          quantity: 100,
          safe_inventory: 20,
          uom_id: uom.id,
          unit_of_measure: "EA"
        }
      }
      expect(response).to have_http_status(:forbidden)
    end

    it "PUT /inventories/:id returns 403" do
      inv = Inventory.create!(part_id: part.id, warehouse_id: wh.id, uom_id: uom.id, quantity: 10, safe_inventory: 2, unit_of_measure: "EA")
      put "/inventories/#{inv.id}", params: { inventory: { quantity: 25 } }
      expect(response).to have_http_status(:forbidden)
    end
  end

  context "authenticated viewer" do
    let!(:viewer) { create(:user, role: "viewer", password: "secret123", password_confirmation: "secret123", email: "viewer@example.com") }
    before do
      sign_in(viewer, scope: :user)
      puts "Debug: Viewer role = '#{viewer.reload.role}'"  
    end

    it "GET /inventories is OK" do
      get "/inventories"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Inventories").or include("Inventory")
    end

    it "GET /inventories/:id is OK" do
      inv = Inventory.first || Inventory.create!(part_id: part.id, warehouse_id: wh.id, uom_id: uom.id, quantity: 1, safe_inventory: 2, unit_of_measure: "EA")
      get "/inventories/#{inv.id}"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Inventory")
    end
  end

  context "authenticated admin" do
    let!(:admin) { create(:user, role: "admin", password: "password123", password_confirmation: "password123", email: "admin@example.com") }
    before do
      post "/sessions", params: { username: admin.username, password: "password123" } 
    end

    it "POST /inventories creates a new inventory record" do
      expect {
        post "/inventories", params: {
          inventory: {
            warehouse_id: wh.id,
            part_id: part.id,
            quantity: 100,
            safe_inventory: 20,
            uom_id: uom.id,
            unit_of_measure: "EA"
          }
        }
      }.to change(Inventory, :count).by(1)

      expect(response).to have_http_status(:redirect)
      expect(Inventory.last.quantity).to eq(100)
      expect(Inventory.last.value).to eq(1000)
    end

    it "PUT /inventories/:id updates inventory qty" do
      inv = Inventory.create!(part_id: part.id, warehouse_id: wh.id, uom_id: uom.id, quantity: 10, safe_inventory: 2, unit_of_measure: "EA")
      put "/inventories/#{inv.id}", params: { inventory: { quantity: 25 } }
      expect(response).to have_http_status(:redirect)
      expect(inv.reload.quantity).to eq(25)
      expect(inv.reload.value).to eq(250)
    end
  end
end