class CreateVendorPartNumbers < ActiveRecord::Migration[8.0]
  def change
    create_table :vendor_part_numbers do |t|
      t.string :vendor_item
      t.references :vendor, null: false, foreign_key: true
      t.references :part, null: false, foreign_key: true

      t.timestamps
    end
  end
end
