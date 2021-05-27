class Product < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :ratings, dependent: :destroy
  belongs_to :category
end
