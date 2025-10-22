class RemovePasswordDigestFromUsers < ActiveRecord::Migration[8.0]
  def change
    safety_assured do
      remove_column :users, :password_digest, :string, null: false, default: nil
    end
  end
end