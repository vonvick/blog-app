FactoryBot.define do
  factory :album do
    title { Faker::Music.album }
    description { Faker::Lorem.paragraph }
    artist { Faker::Artist.name }
    year { Faker::Time.backward(2000).strftime('%Y') }
    association :created_by
  end
end
