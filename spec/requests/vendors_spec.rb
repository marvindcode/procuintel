RSpec.describe "Vendors", type: :request do
  let!(:vendor) { create(:vendor, name: "Acme") }

  context "viewer" do
    let(:user) { create(:user, email: "viewer@example.com", password: "password", role: "viewer") }
    before { sign_in user }

    it "GET /vendors allowed" do
      get vendors_path
      expect(response).to have_http_status(:ok)
    end

    it "POST /vendors forbidden" do
      post vendors_path, params: { vendor: { name: "NewCo" } }
      expect(response).to have_http_status(:found).or have_http_status(:forbidden)
    end
  end

  context "admin" do
    let(:user) { create(:user, email: "admin@example.com", password: "password", role: "admin") }
    before { sign_in user }

    it "creates vendor" do
      expect {
        post vendors_path, params: { vendor: { name: "NewCo" } }
      }.to change(Vendor, :count).by(1)
    end
  end
end
