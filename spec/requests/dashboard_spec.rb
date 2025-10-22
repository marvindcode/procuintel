require "rails_helper"

RSpec.describe "Dashboard", type: :request do
  it "requires login" do
    get "/dashboard"
    expect(response).to redirect_to(new_user_session_path).or have_http_status(:found)
  end

  it "renders for signed-in user" do
    user = create(:user, role: "admin")
    sign_in user
    get "/dashboard"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Procuintel Dashboard")
  end
end
