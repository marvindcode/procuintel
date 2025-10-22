require "rails_helper"

RSpec.describe "Users (sign up)", type: :request do
  it "GET /users/new is public" do
    get new_user_path
    expect(response).to have_http_status(:ok)
  end

  it "POST /users creates a user (public)" do
    post users_path, params: {
      user: {
        name: "A",
        username: "a1_#{rand(1000)}",
        password: "secret123",
        password_confirmation: "secret123",
        role: "viewer"
      }
    }
    expect(response).to redirect_to(root_path) 
    expect(User.last.username).to start_with("a1_")
  end
end