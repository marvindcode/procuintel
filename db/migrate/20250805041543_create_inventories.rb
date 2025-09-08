class CreateInventories < ActiveRecord::Migration[8.0]
  def change
    create_table :inventories do |t|
      t.references :part,      null: false, foreign_key: true
      t.references :warehouse, null: false, foreign_key: true
      t.integer :quantity,        null: false, default foreign_key: true
      t.decimal :inventory_value, null: false
      t.integer :safe_inventory,  null: false
      t.integer :status,          null: false

      t.timestamps
    end

    add_index :inventories, [:warehouse_id, :part_id], unique: true
    add_index :inventories, :part_id
  end
end

