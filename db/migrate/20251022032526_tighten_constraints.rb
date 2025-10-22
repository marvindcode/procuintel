class TightenConstraints < ActiveRecord::Migration[8.0]
  def change
    # Parts
    change_column_null :parts, :part_number, false
    add_index :parts, :part_number, unique: true

    # Inventories
    change_column_null :inventories, :warehouse_id, false
    change_column_null :inventories, :part_id, false
    change_column_default :inventories, :quantity, from: nil, to: 0
    add_foreign_key :inventories, :warehouses
    add_foreign_key :inventories, :parts

    # VendorPartNumbers (composite uniqueness if you want)
    add_index :vendor_part_numbers, [:vendor_id, :part_id], unique: true, name: "idx_vpn_vendor_part"
  end
end
