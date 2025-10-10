require "rails_helper"

RSpec.describe "Parts", type: :request do
  let!(:user) { create(:user, role: "viewer", password: "secret123", password_confirmation: "secret123") }
  let!(:part) do
    Part.first || Part.create!(
      part_number: "ZX0000C",
      name: "Test Part",
      is_active: true,
      price: 1.50,     
      uom: (Uom.first || Uom.create!(code: "EA"))    
    )
  end

  context "unauthenticated" do
    it "GET /parts is forbidden" do
      get "/parts"
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to include("login required")
      expect(response).to redirect_to(new_user_session_path)  
    end

    it "GET /parts/:id is forbidden" do
      get "/parts/#{part.id}"
      expect(response).to have_http_status(:forbidden)
    end


    it "POST /parts is forbidden" do
      post parts_path, params: {
        part: {
          part_number: "ZX00005",
          name: "Part",
          is_active: true,
          price: 2.50,
          uom_id: nil
        }
      }
      expect(response).to have_http_status(:forbidden)
    end
  end

  context "authenticated non-admin (viewer)" do
    let!(:viewer) { create(:user, role: "viewer", password: "password123", password_confirmation: "password123") }
    before { sign_in_as(viewer) }

    it "GET /parts is OK" do
      get "/parts"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Parts")
    end

    it "GET /parts/:id is OK" do
      get "/parts/#{part.id}"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(part.part_number)
    end

    it "POST /parts is forbidden for non-admin" do
      post parts_path, params: {
        part: { part_number: "ZX00006", name: "Nope", is_active: true, price: 3.0 }
      }
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to include("admin only")
    end
  end

  context "authenticated admin" do
    let!(:admin) { create(:user, role: "admin", password: "password123", password_confirmation: "password123") }
    before { sign_in_as(admin) }

    it "creates a part with valid params" do
      post parts_path, params: {
        part: {
          part_number: "ZX00005",
          name: "Part",
          is_active: true,
          price: 2.50
        }
      }
      expect(response).to redirect_to(Part.last)
      follow_redirect!
      expect(response.body).to include("created").or include("success")
      expect(Part.last.part_number).to eq("ZX00005")
    end

    it "fails with invalid params" do
      post parts_path, params: { part: { part_number: "", name: "", is_active: true } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "updates a part" do
      put part_path(part), params: { part: { part_number: "NEW-123", name: "New Name" } }
      expect(response).to redirect_to(part)
      expect(part.reload.part_number).to eq("NEW-123")
      expect(part.reload.name).to eq("New Name")
    end
  end
end
