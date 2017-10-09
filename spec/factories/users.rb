FactoryGirl.define do
  factory :user do
    trait :valid do
      password { Faker::Internet.password(12) }
      username { Faker::Name.first_name }
    end

    trait :invalid do
      password ''
      username { Faker::Name.first_name }
    end
  end
end
