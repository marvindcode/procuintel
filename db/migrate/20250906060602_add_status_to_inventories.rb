class AddStatusToInventories < ActiveRecord::Migration[8.0]
  def change
    add_column :inventories, :status, :integer, null: false, default: 0
    add_index  :inventories, :status
  end
end
