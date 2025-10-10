require "rails_helper"

RSpec.describe "Vendors", type: :request do
  describe "unauthenticated" do
    it "GET /vendors redirects to login" do
      get(vendors_path)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "GET /vendors/:id redirects to login" do
      vendor = Vendor.create!(name: "VendorCo")
      get(vendor_path(vendor))
      expect(response).to redirect_to(new_user_session_path)
    end

    it "POST /vendors redirects to login" do
      post(vendors_path, params: { vendor: { name: "Acme" } })
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "authenticated viewer (read-only)" do
    let!(:user) { create(:user) }
    before { sign_in_as(user) }

    it "GET /vendors is OK" do
      get(vendors_path)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Vendors")
    end

    it "GET /vendors/:id is OK" do
      vendor = Vendor.create!(name: "VendorCo")
      get(vendor_path(vendor))
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(vendor.name)
    end

    it "POST /vendors is forbidden for viewer" do
      expect {
        post(vendors_path, params: { vendor: { name: "Acme" } })
      }.not_to change(Vendor, :count)
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to include("admin only")
    end
  end

  describe "authenticated admin (full CRUD)" do
    let!(:user) { create(:user, role: "admin") }
    before { sign_in_as(user) }

    it "POST /vendors creates a new vendor" do
      expect {
        post(vendors_path, params: { vendor: { name: "Acme" } })
      }.to change(Vendor, :count).by(1)
      expect(response).to have_http_status(:redirect)
      expect(Vendor.last.name).to eq("Acme")
    end
  end
end