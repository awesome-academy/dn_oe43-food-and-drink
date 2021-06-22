FactoryBot.define do
  factory :category do
    name {"Appetizer"}

    factory :category_with_products do
      transient do
        products_count { 5 }
      end

      after(:create) do |category, evaluator|
        create_list(:product, 5, category: category)
      end
    end
  end
end
