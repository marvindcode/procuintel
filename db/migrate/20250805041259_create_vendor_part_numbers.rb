class CreateVendorPartNumbers < ActiveRecord::Migration[8.0]
  def change
    create_table :vendor_part_numbers do |t|
      t.references :vendor, null: false, foreign_key: true
      t.references :part,   null: false, foreign_key: true
      t.string  :vendor_item, null: false
      t.string  :description
      t.references :uom,      null: true, foreign_key: true
      t.decimal :price, null: false
      t.integer :lead_time,  null: true
      t.boolean :is_active,  null: false, default: true

      t.timestamps
    end

    add_index :vendor_part_numbers, :vendor_item
    add_index :vendor_part_numbers, [:vendor_id, :part_id], unique: true

  end
end

