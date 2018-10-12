FactoryBot.define do
  factory :rating do
    rating_score { Faker::Number.between(0, 5) }
    association :created_by, factory: :user
    association :rateable
  end
end
