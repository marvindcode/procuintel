class AddPasswordDigestToUsers < ActiveRecord::Migration[8.0]
  def up
    return if column_exists?(:users, :password_digest)
    add_column :users, :password_digest, :string, null: false, default: ""
  end

  def down
    remove_column :users, :password_digest if column_exists?(:users, :password_digest)
  end
end


