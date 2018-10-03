FactoryBot.define do
  factory :role do
    trait :super_admin do
      title 'super_admin'
      rank 1 
    end

    trait :admin do
      title 'admin'
      rank 2
    end

    trait :moderator do
      title 'moderator'
      rank 3
    end

    trait :user do
      title 'user'
      rank 4
    end
  end
end
