FactoryBot.define do
  factory :category do
    category_name{Faker::Food.ingredient}
  end
end
