FactoryGirl.define do
  factory :group_event do
    user_id 1

    trait :valid do
      user_id 1
      start_date { Faker::Date.forward(23) }
      end_date { start_date + 50.days }
      duration 50
      name { Faker::Book.title }
      description { Faker::Lorem.sentence }
      location { Faker::Hobbit.location }
    end

    trait :invalid_dates do
      user_id 1
      start_date { Faker::Date.forward(23) }
      end_date { start_date - 50.days }
      name { Faker::Book.title }
      description { Faker::Lorem.sentence }
      location { Faker::Hobbit.location }
    end

    trait :with_duration_and_start_date do
      user_id 1
      start_date { Faker::Date.forward(23) }
      duration 50
      name { Faker::Book.title }
      description { Faker::Lorem.sentence }
      location { Faker::Hobbit.location }
    end

    trait :with_duration_and_end_date do
      user_id 1
      end_date { Faker::Date.forward(23) }
      duration 50
      name { Faker::Book.title }
      description { Faker::Lorem.sentence }
      location { Faker::Hobbit.location }
    end
  end
end
