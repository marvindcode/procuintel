class AddUomRefToParts < ActiveRecord::Migration[7.1]
  def change
    add_reference :parts, :uom, index: true, null: true unless column_exists?(:parts, :uom_id)

    if table_exists?(:uoms)
      add_foreign_key :parts, :uoms unless foreign_key_exists?(:parts, :uoms)
    end
  end
end


