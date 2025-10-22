FactoryBot.define do
  factory :order do
      vendor { association :vendor }
      status { "pending" }
      purchase_number { "ORD#{rand(1000)}" }
  end
end