FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:username) { |n| "user#{n}" }
    password { "secret123" }
    password_confirmation { "secret123" }
    role { "viewer" }
  end
end