FactoryBot.define do
  factory :product do
    category
    name { Faker::Food.dish }
    price { Faker::Number.between(from: 1.1, to: 11.0).round(2) }
    quantity { Faker::Number.between(from: 1, to: 74) }
    description { Faker::Food.description }
  end
end
