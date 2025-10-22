require "rails_helper"

RSpec.describe "Parts", type: :request do
  let(:part_params) { { part: { part_number: "P-9999", name: "Test" } } }

  it "viewer cannot create" do
    user = create(:user, role: "viewer")
    sign_in user
    post parts_path, params: part_params
    expect(response).to have_http_status(:found)
    follow_redirect!
    expect(response.body).to include("Not authorized.")
  end

  it "admin can create" do
    user = create(:user, role: "admin")
    sign_in user
    expect { post parts_path, params: part_params }.to change(Part, :count).by(1)
  end
end
