class CreateVendors < ActiveRecord::Migration[8.0]
  def change
    create_table :vendors do |t|
      t.string :name
      t.string :vendor_number
      t.string :role
      t.string :location

      t.timestamps
    end
  end
end
