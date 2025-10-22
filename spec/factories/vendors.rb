FactoryBot.define do
  factory :vendor do
    sequence(:name) { |n| "Vendor #{n}" }
    vendor_number { "V#{rand(1000)}" }
    location { "NY" }
  end
end