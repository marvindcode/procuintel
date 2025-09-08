class CreateVendorLeadTimes < ActiveRecord::Migration[8.0]
  def change
    create_table :vendor_lead_times do |t|
      t.references :vendor, null: false, index: true   
      t.references :part,   null: false, index: true   
      t.integer :expected_lead_time
      t.integer :actual_lead_time
      t.timestamps
    end

    add_index :vendor_lead_times, [:vendor_id, :part_id], unique: true
    add_foreign_key :vendor_lead_times, :vendors
    add_foreign_key :vendor_lead_times, :parts
  end
end
