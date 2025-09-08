class EnsureStatusEnumOnOrders < ActiveRecord::Migration[8.0]
  def up
    if column_exists?(:orders, :status, :integer)
    elsif column_exists?(:orders, :status)
      rename_column :orders, :status, :status_text
      add_column :orders, :status, :integer, null: false, default: 0
      execute <<~SQL.squish
        UPDATE orders
        SET status = CASE LOWER(COALESCE(status_text, 'draft'))
          WHEN 'draft'    THEN 0
          WHEN 'pending'  THEN 1
          WHEN 'approved' THEN 2
          WHEN 'received' THEN 3
          WHEN 'canceled' THEN 4
          ELSE 0
        END
      SQL
      remove_column :orders, :status_text
    else
      add_column :orders, :status, :integer, null: false, default: 0
    end

    add_index :orders, :status unless index_exists?(:orders, :status)
  end

  def down
    remove_index :orders, :status if index_exists?(:orders, :status)
    remove_column :orders, :status if column_exists?(:orders, :status)
  end
end
