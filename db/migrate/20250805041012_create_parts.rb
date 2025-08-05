class CreateParts < ActiveRecord::Migration[8.0]
  def change
    create_table :parts do |t|
      t.string :part_number
      t.string :name
      t.string :category
      t.text :description
      t.decimal :price
      t.string :uom
      t.integer :lead_time

      t.timestamps
    end
  end
end
