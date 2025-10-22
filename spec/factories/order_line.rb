FactoryBot.define do
  factory :order_line do
      part { association :part }
      quantity { 1 }
      price { 1.0 }
      uom { association :uom }
  end
end  