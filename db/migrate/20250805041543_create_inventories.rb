class CreateInventories < ActiveRecord::Migration[8.0]
  def change
    create_table :inventories do |t|
      t.integer :quantity
      t.string :unit_of_measure
      t.decimal :value
      t.integer :safe_inventory
      t.references :warehouse, null: false, foreign_key: true
      t.references :part, null: false, foreign_key: true

      t.timestamps
    end
  end
end
