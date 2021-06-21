FactoryBot.define do
  factory :order_item do
    order
    product
    quantity { Faker::Number.between(from: 1, to: 28) }
  end
end
