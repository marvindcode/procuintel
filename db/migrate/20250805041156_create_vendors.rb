class CreateVendors < ActiveRecord::Migration[8.0]
  def change
    create_table :vendors do |t|
      t.string :name
      t.string :vendor_number
      t.string :location
      
      t.timestamps
    end

    add_index :vendors, :vendor_number, unique: true
  end
end