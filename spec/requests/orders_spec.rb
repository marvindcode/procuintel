require "rails_helper"
RSpec.describe "Orders", type: :request do
  it "GET /orders is OK" do
    get "/orders"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Orders")
  end

  it "GET /orders/:id is OK" do
    user  = User.first_or_create!(name: "Demo", email: "demo@example.com")
    order = Order.first || Order.create!(purchase_number: "PO-1", user: user, order_total: 0, status: :pending)

    get "/orders/#{order.id}"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Order ")
  end
end

