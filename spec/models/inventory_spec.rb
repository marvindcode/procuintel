require "rails_helper"

RSpec.describe Inventory, type: :model do
  it "low_stock? is true when quantity <= safe_inventory" do
    inv = build(:inventory, quantity: 5, safe_inventory: 10)
    expect(inv.low_stock?).to be true
  end

  it "low_stock? is false when safe_inventory is nil" do
    inv = build(:inventory, quantity: 5, safe_inventory: nil)
    expect(inv.low_stock?).to be false
  end

  it ".low_stock returns the right rows" do
    a = create(:inventory, quantity: 3, safe_inventory: 5)
    b = create(:inventory, quantity: 10, safe_inventory: 5)
    expect(Inventory.low_stock).to include(a)
    expect(Inventory.low_stock).not_to include(b)
  end
end
