class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  belongs_to :user

  enum status: {
    waiting: 0,
    approved: 1,
    delivering: 2,
    delivered: 3,
    canceled: 4
  }

  scope :latest, ->{order(created_at: :desc)}
  scope :group_by_status, ->(status){where("status = ?", status)}

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

  def cancel_order
    raise StandardException if order_items.empty?

    order_items.each do |item|
      product = Product.find_by! id: item.product_id
      product.update! quantity: product.quantity + item.quantity
    end
    canceled!
  end

  validates :address, presence: true
  validates :name, presence: true
  validates :phone, format: {with: Settings.order.address.regex}
end
