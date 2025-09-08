class CreateVendors < ActiveRecord::Migration[8.0]
  def change
    create_table :vendors do |t|
      t.string :name, null: false
      t.string :location
      t.string :vendor_number
      t.string :vendor_type

      t.timestamps
    end

    add_index :vendors, :vendor_number
    add_index :vendors, :name
  end
end
