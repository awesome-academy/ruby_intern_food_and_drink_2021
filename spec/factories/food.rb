FactoryBot.define do
  factory :food do
    name{Faker::Food.fruits}
    description{Faker::Food.description}
    price{10000}
    quantity{3}
    status{1}
    category_id {create(:category).id}
  end
end
