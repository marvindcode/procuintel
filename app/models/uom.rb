class Uom < ApplicationRecord
  has_many :parts

  validates :code, presence: true, uniqueness: true
end

