FactoryBot.define do
  factory :cart do
    quantity { 3 }
    total { 300000 }
    order_id { create(:order).id }
    food_id { create(:food).id }
  end
end
