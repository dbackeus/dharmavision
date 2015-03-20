FactoryGirl.define do
  sequence(:email) { |n| "test#{n}@test.com" }

  factory :user do
    email
    password "testtest"
    password_confirmation "testtest"
  end

  factory :movie do
    imdb_id "0169102"
    association :creator, factory: :user
  end
end
