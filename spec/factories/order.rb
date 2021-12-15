FactoryBot.define do
  factory :order do
    address{Faker::Address.street_address}
    phone{Faker::PhoneNumber.phone_number}
    user_id{create(:user).id}
  end
end
