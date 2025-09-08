class User < ApplicationRecord
  enum :user_role, { viewer: 0, buyer: 1, admin: 2 } 

  has_many :orders, dependent: :nullify
  validates :name,  presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
end
