User.create!(name: "Quan Van Chung",
  email:"quan.van.chung@sun-asterisk.com",
  password: "chung123",
  password_confirmation: "chung123",
  role: true,
  activated: true,
  activated_at: Time.zone.now)
# Fake accounts
20.times do |n|
  name = Faker::Name.unique.name
  email = "example-#{n+1}@test.com"
  password = "chung123"
  u = User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   role: false,
                   activated: true,
                   activated_at: Time.zone.now)
end
# Fake categorys
10.times do |n|
  name = Faker::Food.ingredient
  Category.create!(category_name: name)
end
# Fake foods
categories = Category.order(:created_at).take(6)
30.times do |n|
  name = Faker::Food.fruits
  description = Faker::Food.description
  categories.each do |category|
    category.foods.create!(name: name,
                           price: 100000,
                           description: description,
                           quantity: 3,
                           status: true)
  end
end
# Fake orders
User.all.sample(10).each do |user|
  phone = Faker::PhoneNumber.cell_phone
  address = Faker::Address.full_address
  food = Food.all.sample(1)
  order = user.orders.create!(
    phone: phone,
    address: address)
  order.carts.create!(
    quantity: 2,
    food_id: food[0].id)
end
User.all.sample(2).each do |user|
  phone = Faker::PhoneNumber.cell_phone
  address = Faker::Address.full_address
  food = Food.all.sample(1)
  order = user.orders.create!(
    phone: phone,
    address: address,
    status: "shipping")
  order.carts.create!(
    quantity: 2,
    food_id: food[0].id)
end
