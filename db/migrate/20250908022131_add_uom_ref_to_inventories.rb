class AddUomRefToInventories < ActiveRecord::Migration[8.0]
  def change
    add_reference :inventories, :uom, index: true, null: true unless column_exists?(:inventories, :uom_id)
    add_foreign_key :inventories, :uoms unless foreign_key_exists?(:inventories, :uoms)
  end
end
