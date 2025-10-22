FactoryBot.define do
  factory :inventory do
  
    quantity { 10 }
    safe_inventory { 5 }

    association :part
    association :warehouse
    association :uom
  
  end
end