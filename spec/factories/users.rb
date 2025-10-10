FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }  # From previous fix
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    role { "viewer" }

    # NEW: Set password_digest for NOT NULL constraint (uses BCrypt)
    password_digest { BCrypt::Password.create("password123") }

    # Trait for admin
    trait :admin do
      role { "admin" }
    end

    # Factory using trait
    factory :admin_user, traits: [:admin]
  end
end