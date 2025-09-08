class CreateOrderLines < ActiveRecord::Migration[8.0]
  def change
    create_table :order_lines do |t|
      t.references :order, null: false, foreign_key: true
      t.references :part,  null: false, foreign_key: true
      t.integer :quantity, null: false
      t.references :unit_of_measure,  null: true,  foreign_key: true
      t.decimal :price, null: false

      t.timestamps
    end

    add_index :order_lines, :order_id
    add_index :order_lines, :part_id
  end
end
