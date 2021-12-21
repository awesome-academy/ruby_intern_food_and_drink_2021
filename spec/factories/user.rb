FactoryBot.define do
  factory :user do
    name{Faker::Name.name_with_middle}
    email{Faker::Internet.email.downcase}
    phone{Faker::PhoneNumber.cell_phone}
    address{Faker::Address.full_address}
    password{"chung123"}
    password_confirmation{"chung123"}
  end
end
