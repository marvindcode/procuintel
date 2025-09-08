class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string     :purchase_number, null: false
      t.references :user,            null: false, foreign_key: true
      t.decimal    :order_total,     null: false
      t.integer    :status,          null: false

      t.timestamps
    end

    add_index :orders, :purchase_number, unique: true
  end
end
