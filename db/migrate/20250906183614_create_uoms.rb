class CreateUoms < ActiveRecord::Migration[8.0]
  def change
    create_table :uoms do |t|
      t.string :code, null: false
      t.string :description
      t.timestamps
    end
    add_index :uoms, :code, unique: true
  end
end
