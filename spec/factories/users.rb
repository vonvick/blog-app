FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    username { Faker::Internet.username }
    uid { Faker::Internet.email }
    association :role
  end
end
