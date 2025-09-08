class AddIsActiveToParts < ActiveRecord::Migration[8.0]
  def change
    add_column :parts, :is_active, :boolean, null: false, default: true
    add_index  :parts, :is_active
  end
end
