class AddVendorToOrders < ActiveRecord::Migration[8.0]
  def up
    return if column_exists?(:orders, :vendor_id)
    add_reference :orders, :vendor, null: false, foreign_key: true
  end

  def down
    remove_reference :orders, :vendor, foreign_key: true if column_exists?(:orders, :vendor_id)
  end
end


