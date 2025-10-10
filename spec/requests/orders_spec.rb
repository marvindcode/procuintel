require "rails_helper"

RSpec.describe "Orders", type: :request do
  let!(:user)   { create(:user, role: "buyer") }
  let!(:vendor) { Vendor.first || Vendor.create!(name: "VendorCo") }
  let!(:uom)    { Uom.first || Uom.create!(code: "EA") }
  let!(:part)   do
    Part.first || Part.create!(part_number: "P-1", name: "Test Part", is_active: true, price: 1.0, uom: uom)
  end

  before { sign_in_as(user) }

  it "GET /orders is OK and renders list" do
    get "/orders"
    expect(response).to have_http_status(:ok)
  end

  it "GET /orders/:id is OK and shows the order" do
    order = Order.create!(user: user, vendor: vendor, status: "pending")
    get "/orders/#{order.id}"
    expect(response).to have_http_status(:ok)
  end

  describe "POST /orders" do
    it "creates an order with lines" do
      post "/orders", params: {
        order: {
          vendor_id: vendor.id,
          status: "pending",
          order_lines_attributes: [
            { part_id: part.id, quantity: 2, price: 1.5, uom_id: uom.id }
          ]
        }
      }
      expect(response).to have_http_status(:redirect)
      expect(Order.last.order_lines.count).to be > 0
    end

    it "fails when vendor is missing" do
      post "/orders", params: { order: { status: "pending" } }
      expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:bad_request)
    end
  end

  describe "PUT /orders/:id" do
    it "updates lines (e.g., change qty)" do
      order = Order.create!(vendor: vendor, status: "pending")
      ol = order.order_lines.create!(part: part, quantity: 1, price: 1.0, uom: uom)

      put "/orders/#{order.id}", params: {
        order: {
          order_lines_attributes: [
            { id: ol.id, quantity: 5 }
          ]
        }
      }
      expect(response).to have_http_status(:redirect)
      expect(ol.reload.quantity).to eq(5)
    end

    it "returns unprocessable when invalid" do
      order = Order.create!(vendor: vendor, status: "pending")
      put "/orders/#{order.id}", params: { order: { status: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end

