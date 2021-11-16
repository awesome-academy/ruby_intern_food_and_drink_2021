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
User.create!(name: "Quan Van Chung",
             email:"quan.van.chung@sun-asterisk.com",
             password: "chung123",
             password_confirmation: "chung123",
             role: true,
             activated: true,
             activated_at: Time.zone.now)
