class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  belongs_to :user

  enum status: {
    waiting: 0,
    delivering: 1,
    delivered: 2,
    canceled: 3
  }

  scope :latest, ->{order(created_at: :desc)}

  def add_order_items cart, total
    cart.each do |k, v|
      item = order_items.build product_id: k,
                                    quantity: v
      item.save!
      product = Product.find_by! id: k
      product.update! quantity: product.quantity - v
    end
    update! total: total
  end

  validates :address, presence: true
  validates :name, presence: true
  validates :phone, format: {with: Settings.order.address.regex}
end
