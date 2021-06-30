class Product < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :ratings, dependent: :destroy
  belongs_to :category

  scope :asc_name, ->{order :name}
  scope :load_cart, ->(product_ids){where(id: product_ids)}
end
