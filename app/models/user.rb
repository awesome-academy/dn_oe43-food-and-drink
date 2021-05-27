class User < ApplicationRecord
  has_many :orders
  has_many :ratings

  enum role: [:user,:guard, :official, :admin]
end
