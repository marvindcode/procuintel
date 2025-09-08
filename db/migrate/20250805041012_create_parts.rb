class CreateParts < ActiveRecord::Migration[8.0]
  def change
    create_table :parts do |t|
      t.string :part_number,     null: false
      t.string :name,   null: false
      t.string :category
      t.text :description
      t.decimal :price
      t.string :unit_of_measure,  null: true
      t.integer :lead_time
      t.boolean :is_active,  null: false

      t.timestamps
    end

    add_index :parts, :part_number, unique: true
    add_index :parts, :name
  end
end
