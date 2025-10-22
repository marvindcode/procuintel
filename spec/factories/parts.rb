FactoryBot.define do
  factory :part do
    sequence(:part_number) { |n| "P-#{n}" }
    name { "Test Part" }
    is_active { true }
    price { 1.50 }
    uom { association :uom }
  end
end