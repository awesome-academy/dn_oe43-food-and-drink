Category.create!(name: "Appetizers")
Category.create!(name: "Main dishes")
Category.create!(name: "Desserts")
Category.create!(name: "Coke")
Category.create!(name: "Milktea")
Category.create!(name: "Coffee")

Product.create!(name: "Crab Noodle Soup",
                price: 1.2,
                quantity: 250,
                description: "Best Noodle in The World",
                category_id: 2)

categories = Category.order(:created_at).take(6)
11.times do
  name = Faker::Food.dish
  price = Faker::Number.between(from: 1.1, to: 11.0).round(2)
  quantity = Faker::Number.between(from: 1, to: 74)
  description = Faker::Food.description
  categories.each do |category|
    category.products.create!(name: name,
                              price: price,
                              quantity: quantity,
                              description: description)
  end
end

