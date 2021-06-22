FactoryBot.define do
  factory :user do
    name { Faker::Name.name}
    email { Faker::Internet.email }
    password  {"123123"}
    password_confirmation {"123123"}

    factory :user_with_orders do
      transient do
        orders_count {15}
      end

      after(:create) do |user, evaluator|
        create_list(:order_with_items, evaluator.orders_count, user: user)
        user.reload
      end
    end
  end
end
