require "rails_helper"

RSpec.describe "Orders", type: :request do
  let!(:user)   { User.first_or_create!(name: "Demo", email: "demo@example.com") }
  let!(:vendor) { Vendor.first_or_create!(name: "Acme") }
  let!(:part)   do
    Part.first_or_create!(
      part_number: "P-100",
      name: "Test Part",
      is_active: true,
      unit_of_measure: "EA",
      value: 1.5
    )
  end

  describe "GET /orders" do
    it "is OK and renders list" do
      get orders_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Orders")
    end
  end

  describe "GET /orders/:id" do
    it "is OK and shows the order" do
      order = Order.first ||
              Order.create!(
                purchase_number: "P012345",
                vendor: vendor,
                user: user,
                order_total: 0,
                status: :pending
              )

      get order_path(order)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Order")
    end
  end

  describe "POST /orders" do
    it "creates an order with lines" do
      post orders_path, params: {
        order: {
          vendor_id: vendor.id,
          purchase_number: "PO-1234",
          order_date: Date.today,
          status: :draft,
          order_lines_attributes: [
            { part_id: part.id, quantity: 10, price: 1.75, unit_of_measure: "EA" }
          ]
        }
      }

      expect(response).to redirect_to(Order.last)
      order = Order.last
      expect(order.order_lines.count).to eq(1)
      expect(order.order_lines.first.quantity).to eq(10)
    )
    end

    it "fails when vendor is missing" do
      post orders_path, params: {
        order: {
          purchase_number: "PO-FAIL",
          order_date: Date.today,
          order_lines_attributes: [
            { part_id: part.id, quantity: 1, price: 1.0, unit_of_measure: "EA" }
          ]
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /orders/:id" do
    it "updates lines (e.g., change qty)" do
      order = Order.create!(
        vendor: vendor,
        user: user,
        purchase_number: "PO-2001",
        order_date: Date.today,
        status: :draft
      )
      line  = order.order_lines.create!(part_id: part.id, quantity: 5, price: 2.0, unit_of_measure: "EA")

      put order_path(order), params: {
        order: {
          order_lines_attributes: [
            { id: line.id, quantity: 8 } 
          ]
        }
      }

      expect(response).to redirect_to(order)
      expect(line.reload.quantity).to eq(8)
    end

    it "returns unprocessable when invalid (e.g., blank purchase_number if required)" do
      order = Order.create!(
        vendor: vendor,
        user: user,
        purchase_number: "PO-KEEP",
        order_date: Date.today,
        status: :draft
      )

      put order_path(order), params: { order: { purchase_number: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end

