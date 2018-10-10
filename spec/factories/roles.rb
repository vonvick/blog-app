FactoryBot.define do
  factory :role do
    trait :admin do
      title { 'admin' }
      rank { 1 }
    end

    trait :moderator do
      title { 'moderator' }
      rank { 2 }
    end

    trait :user_role do
      title { 'user' }
      rank { 3 }
    end
  end
end
