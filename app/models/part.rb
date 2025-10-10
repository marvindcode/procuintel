class Part < ApplicationRecord
  belongs_to :uom, optional: true

  has_many :order_lines, dependent: :nullify if defined?(OrderLine)

  validates :part_number, presence: true, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  before_validation :normalize_part_number

  private

  def normalize_part_number
    self.part_number = part_number.to_s.strip.upcase
  end
end
