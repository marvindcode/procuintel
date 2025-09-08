class AddUserRoleToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :user_role, :integer, null: false, default: 0 unless column_exists?(:users, :user_role)
    add_index  :users, :user_role unless index_exists?(:users, :user_role)
  end
end
