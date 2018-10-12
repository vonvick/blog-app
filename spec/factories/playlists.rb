FactoryBot.define do
  factory :playlist do
    title { Faker::Music.album }
    description { Faker::Lorem.paragraph }
    association :owner
  end
end
