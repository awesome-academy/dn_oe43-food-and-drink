class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :ratings, dependent: :destroy

  enum role: {
    user: 0,
    admin: 1
  }

  has_secure_password
end
