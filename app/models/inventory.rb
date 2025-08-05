class Inventory < ApplicationRecord
  belongs_to :warehouse
  belongs_to :part
end
