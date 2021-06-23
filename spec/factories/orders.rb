FactoryBot.define do
  factory :order do
    user
    name { Faker::Name.name }
    status { Faker::Number.between(from: 0, to: 4) }
    phone { "0905123456" }
    address { Faker::Address.full_address }

    factory :order_with_items do
      transient do
        order_items_count {3}
      end

      after(:create) do |order, evaluator|
        create_list(:order_item, evaluator.order_items_count, order: order)
        order.reload
      end
    end
  end
end
