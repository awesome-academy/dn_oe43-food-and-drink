class Product < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :ratings, dependent: :destroy
  belongs_to :category

  scope :asc_name, ->{order :name}
  scope :load_cart, ->(product_ids){where(id: product_ids)}
  scope :search, (lambda do |query|
                    if query
                      where("name like ? or description like ?",
                            "%#{query}%", "%#{query}%")
                    end
                  end)
  scope :filters, ->(filters){where("category_id = ?", filters)}
  scope :asc_price, ->{order :price}
  scope :desc_price, ->{order(price: :desc)}
end
