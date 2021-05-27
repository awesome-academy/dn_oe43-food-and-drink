class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  belongs_to :user

  enum status: {
    waiting: 0,
    delivering: 1,
    delivered: 2
  }
end
