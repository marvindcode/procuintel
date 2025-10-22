class UsersForAuth < ActiveRecord::Migration[8.0]
  class User < ApplicationRecord
    self.table_name = "users"
  end

  def up
    add_column :users, :username, :string          unless column_exists?(:users, :username)
    add_column :users, :password_digest, :string   unless column_exists?(:users, :password_digest)
    add_column :users, :role, :string              unless column_exists?(:users, :role)

    User.reset_column_information

    if column_exists?(:users, :username)
      say_with_time "Backfilling usernames/roles" do
        User.find_each do |u|
          if u.username.blank?
            base = (u.email.to_s.split("@").first.presence ||
                    u.name.to_s.gsub(/[^a-zA-Z0-9_]+/, "_").presence ||
                    "user_#{u.id}")
            candidate = base
            n = 1
            while User.where.not(id: u.id).exists?(username: candidate)
              n += 1
              candidate = "#{base}_#{n}"
            end
            u.username = candidate
          end

          if column_exists?(:users, :role) && u.role.blank?
            if column_exists?(:users, :user_role)
           
              u.role = case u.user_role
                       when 0, "0", :viewer then "viewer"
                       when 1, "1", :buyer  then "buyer"
                       when 2, "2", :admin  then "admin"
                       else u.user_role.presence || "viewer"
                       end
            else
              u.role ||= "viewer"
            end
          end

          u.save!(validate: false)
        end
      end
    end

    add_index :users, :username, unique: true unless index_exists?(:users, :username, unique: true)

    change_column_null :users, :username, false if column_exists?(:users, :username)
    change_column_null :users, :role,     false if column_exists?(:users, :role)

    remove_column :users, :user_role, :integer if column_exists?(:users, :user_role)
  end

  def down
    add_column :users, :user_role, :integer unless column_exists?(:users, :user_role)
    execute "UPDATE users SET user_role = 0 WHERE user_role IS NULL" if column_exists?(:users, :user_role)

    remove_index :users, :username if index_exists?(:users, :username)

    change_column_null :users, :username, true if column_exists?(:users, :username)
    change_column_null :users, :role,     true if column_exists?(:users, :role)
    change_column_null :users, :password_digest, true if column_exists?(:users, :password_digest)

    remove_column :users, :username        if column_exists?(:users, :username)
    remove_column :users, :password_digest if column_exists?(:users, :password_digest)
    remove_column :users, :role            if column_exists?(:users, :role)
  end
end

