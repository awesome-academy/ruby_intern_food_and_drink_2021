FactoryBot.define do
  factory :order do
    address{Faker::Address.street_address}
    phone{Faker::PhoneNumber.phone_number}
    total{200000}
    user_id{create(:user).id}
  end
end
