# db/seeds.rb
require "csv"
require "bigdecimal"

# ---------- helpers ----------
def load_csv(filename)
  path = Rails.root.join("db", "data", filename)
  unless File.exist?(path)
    puts "⚠️  CSV not found: #{path}"
    return []
  end
  CSV.read(path, headers: true).map(&:to_h)
end

def dec(val)
  s = val.to_s.strip
  return nil if s.empty?
  BigDecimal(s)
end

def int_or_nil(val)
  s = val.to_s.strip
  s.empty? ? nil : s.to_i
end

def find_warehouse_from_row(row)
  if row["warehouse_id"].present?
    Warehouse.find_by(id: row["warehouse_id"].to_i)
  elsif row["warehouse_name"].present?
    Warehouse.find_by(name: row["warehouse_name"])
  elsif row["warehouse_code"].present?
    # Your schema has no warehouses.code; treat code as name fallback
    if Warehouse.column_names.include?("code")
      Warehouse.find_by(code: row["warehouse_code"])
    else
      Warehouse.find_by(name: row["warehouse_code"])
    end
  end
end

# ---------- seeding ----------
ActiveRecord::Base.transaction do
  # UOMs
  uom_rows = load_csv("uoms.csv")
  uom_rows.each do |row|
    code = row["code"].to_s.strip
    next if code.empty?
    Uom.find_or_create_by!(code: code) do |u|
      u.description = row["description"].presence || row["name"]
    end
  end
  puts "✅ UOMs processed: #{uom_rows.size}"

  # Warehouses (schema: name, location)
  wh_rows = load_csv("warehouses.csv")
  wh_rows.each do |row|
    name = row["name"].to_s.strip
    next if name.empty?
    Warehouse.find_or_create_by!(name: name) do |w|
      w.location = row["location"]
    end
  end
  puts "✅ Warehouses: #{wh_rows.size} rows processed"

  # Parts (schema includes uom (string) and uom_id (FK))
  part_rows = load_csv("parts.csv")
  part_rows.each do |row|
    pn = row["part_number"].to_s.strip
    next if pn.empty?

    part = Part.find_or_initialize_by(part_number: pn)
    part.name        = row["name"]
    part.category    = row["category"]
    part.description = row["description"]
    part.price       = dec(row["price"]) if row.key?("price")
    part.lead_time   = int_or_nil(row["lead_time"]) if row.key?("lead_time")
    part.is_active   = row["is_active"].to_s.strip.downcase == "false" ? false : true

    if row["uom_id"].present?
      part.uom_id = row["uom_id"].to_i
    elsif row["uom_code"].present?
      u = Uom.find_or_create_by!(code: row["uom_code"])
      part.uom_id = u.id
    elsif row["uom"].present?
      part.uom = row["uom"]
    end

    part.save!
  end
  puts "✅ Parts processed: #{part_rows.size}"

  # Inventories (schema has unit_of_measure, value, safe_inventory, uom_id)
  inv_rows = load_csv("inventories.csv")
  inv_rows.each do |row|
    wh = find_warehouse_from_row(row)
    pr = if row["part_id"].present?
      Part.find_by(id: row["part_id"].to_i)
    elsif row["part_number"].present?
      Part.find_by(part_number: row["part_number"])
    end

    if wh.nil? || pr.nil?
      puts "⚠️  Skipping inventory row (missing warehouse/part): #{row.inspect}"
      next
    end

    inv = Inventory.find_or_initialize_by(warehouse_id: wh.id, part_id: pr.id)
    inv.quantity        = int_or_nil(row["quantity"]) || 0
    inv.safe_inventory  = int_or_nil(row["safe_inventory"])
    inv.unit_of_measure = row["unit_of_measure"].presence || pr.uom || "ea"
    inv.value           = dec(row["value"]) || pr.price

    if row.key?("status") && !row["status"].to_s.strip.empty?
      s = row["status"].to_s.strip
      inv.status = Integer(s) rescue s
    end

    if row["uom_id"].present?
      inv.uom_id = row["uom_id"].to_i
    elsif row["uom_code"].present?
      u = Uom.find_or_create_by!(code: row["uom_code"])
      inv.uom_id = u.id
    end

    inv.save!
  end
  puts "✅ Inventories processed: #{inv_rows.size}"

  # Demand Forecasts (schema: part_id, warehouse_id, forecast_date, forecast_quantity)
  df_rows = load_csv("demand_forecasts.csv")
  df_rows.each do |row|
    part = if row["part_id"].present?
      Part.find_by(id: row["part_id"].to_i)
    elsif row["part_number"].present?
      Part.find_by(part_number: row["part_number"])
    end
    wh = find_warehouse_from_row(row)

    if part.nil? || wh.nil?
      puts "⚠️  Skipping forecast row (missing part/warehouse): #{row.inspect}"
      next
    end

    date =
      if row["forecast_date"].present?
        begin
          Date.parse(row["forecast_date"])
        rescue ArgumentError
          nil
        end
      end
    if date.nil?
      puts "⚠️  Skipping forecast row (invalid forecast_date): #{row.inspect}"
      next
    end

    df = DemandForecast.find_or_initialize_by(
      part_id: part.id,
      warehouse_id: wh.id,
      forecast_date: date
    )
    df.forecast_quantity = int_or_nil(row["forecast_quantity"]) || 0
    df.save!
  end
  puts "✅ DemandForecasts processed: #{df_rows.size}"

  # Users (Devise)
  admin = User.find_or_initialize_by(email: "admin@example.com")
  if admin.new_record?
    admin.username = "admin"
    admin.role     = "admin"
    admin.name     = "Admin"
    admin.password = "password"
    admin.password_confirmation = "password"
    admin.save!
    puts "👤 Created admin: admin@example.com / password"
  end

  viewer = User.find_or_initialize_by(email: "viewer@example.com")
  if viewer.new_record?
    viewer.username = "viewer"
    viewer.role     = "viewer"
    viewer.name     = "Viewer"
    viewer.password = "password"
    viewer.password_confirmation = "password"
    viewer.save!
    puts "👤 Created viewer: viewer@example.com / password"
  end

  user_rows = load_csv("users.csv")
  if user_rows.any?
    user_rows.each do |row|
      email = row["email"].to_s.strip
      next if email.empty?
      u = User.find_or_initialize_by(email: email)
      u.username = row["username"].presence || email.split("@").first
      u.role     = (row["role"].presence || "viewer")
      u.name     = row["name"].presence || u.username.titleize
      pwd        = (row["password"].presence || "password")
      u.password = pwd
      u.password_confirmation = pwd
      u.save!
    end
    puts "✅ Users from users.csv processed: #{user_rows.size} (default pwd 'password' if omitted)"
  else
    puts "ℹ️  No users.csv found; using default admin/viewer accounts."
  end
end

if Warehouse.count.zero? && Part.count.zero? && Inventory.count.zero?
  puts "ℹ️  No CSV data created; generating minimal demo dataset..."

  w = Warehouse.find_or_create_by!(name: "Main DC") { |x| x.location = "San Jose" }

  p1 = Part.find_or_create_by!(part_number: "P-1001") do |x|
    x.name = 'Bolt 1/4"'
    x.category = "Hardware"
    x.description = "Zinc plated bolt"
    x.price = 0.12
    x.uom = "ea"
    x.lead_time = 7
    x.is_active = true
  end

  p2 = Part.find_or_create_by!(part_number: "BX-200") do |x|
    x.name = "Cardboard Box"
    x.category = "Packaging"
    x.description = "12x9x4 box"
    x.price = 0.55
    x.uom = "ea"
    x.lead_time = 3
    x.is_active = true
  end

  Inventory.find_or_create_by!(warehouse: w, part: p1) do |i|
    i.quantity = 50
    i.safe_inventory = 100
    i.unit_of_measure = "ea"
    i.value = 0.12
  end

  Inventory.find_or_create_by!(warehouse: w, part: p2) do |i|
    i.quantity = 200
    i.safe_inventory = 150
    i.unit_of_measure = "ea"
    i.value = 0.55
  end

  puts "✅ Created fallback demo data (1 warehouse, 2 parts, 2 inventories)."
end

puts "🎉 Seeding complete!"

