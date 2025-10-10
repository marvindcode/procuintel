class CreateInventories < ActiveRecord::Migration[8.0]
  def change
    create_table :inventories do |t|
      t.integer :quantity,       null: false, default: 0
      t.string  :unit_of_measure
      t.decimal :value,          precision: 12, scale: 2, null: false, default: 0
      t.integer :safe_inventory, null: false, default: 0

      t.references :warehouse, null: false
      t.references :part,      null: false

      t.integer :status, null: false, default: 0
      t.timestamps
    end

    add_foreign_key :inventories, :warehouses
    add_foreign_key :inventories, :parts
  end
end
