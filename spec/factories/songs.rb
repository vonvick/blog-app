FactoryBot.define do
  factory :song do
    title { Faker::Music.album }
    genre { Faker::Music.genre }
    artist { Faker::Artist.name }
    track { Faker::Number.between(1, 100) }
    play_count { Faker::Number.digit }
    association :created_by
    association :album
  end
end
