class Warehouse < ApplicationRecord
  has_many :inventories, dependent: :destroy
  has_many :parts, through: :inventories
  has_many :demand_forecasts, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
