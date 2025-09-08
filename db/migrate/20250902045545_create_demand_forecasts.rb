class CreateDemandForecasts < ActiveRecord::Migration[8.0]
  def change
    create_table :demand_forecasts do |t|
      t.references :part,      null: false, index: true   
      t.references :warehouse, null: false, index: true  
      t.date    :forecast_date,     null: false
      t.integer :forecast_quantity, null: false, default: 0
      t.timestamps
    end

    add_index :demand_forecasts, [:part_id, :warehouse_id, :forecast_date],
              unique: true, name: "idx_forecast_uniqueness"
    add_foreign_key :demand_forecasts, :parts
    add_foreign_key :demand_forecasts, :warehouses
  end
end
