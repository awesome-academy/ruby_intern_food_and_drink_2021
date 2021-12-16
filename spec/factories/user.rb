FactoryBot.define do
  factory :user do
    name{Faker::Name.name_with_middle}
    email{Faker::Internet.email.downcase}
    password{"chung123"}
    password_confirmation{"chung123"}
  end
end
