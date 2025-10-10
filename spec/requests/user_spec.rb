require "rails_helper"

RSpec.describe "Users (sign up)", type: :request do
  before do
    host! "www.example.com"
  end

  it "debug host" do
    get new_user_registration_path  
    puts "HOST SEEN: #{request.host}"
  end

  it "GET /users/new is public" do
    get new_user_registration_path  
    expect(response).to have_http_status(:ok)
  end

  it "POST /users creates a user (public)" do
    post user_registration_path, params: {  
      user: {
        name: "A",
        username: "a1_#{rand(1000)}", 
        email: "a@example.com",  
        password: "secret123",
        password_confirmation: "secret123",
        role: "viewer"
      }
    }
    expect(response).to have_http_status(:redirect).or have_http_status(:found)
  end
end