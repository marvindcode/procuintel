class CreateOrderLines < ActiveRecord::Migration[8.0]
  def change
    create_table :order_lines do |t|
      t.references :order, null: false, foreign_key: true
      t.references :part, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price
      t.string :unit_of_measure

      t.timestamps
    end
  end
end
