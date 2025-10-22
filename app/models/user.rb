class User < ApplicationRecord
  # devise modules…
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :trackable

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  before_validation do
    self.username = username.to_s.strip.downcase.presence
    self.email    = email.to_s.strip.downcase.presence
  end
end
