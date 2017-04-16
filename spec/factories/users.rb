FactoryGirl.define do
  factory :user do
    password "password"
    address "KL, Malaysia"
    trait :with_image do
      image { fixture_file_upload("#{::Rails.root}/spec/fixtures/Camera.jpg") }
    end

    trait :sequenced_email do
      sequence(:email) { |n| "user#{n}@email.com" }
    end

    trait :sequenced_username do
      sequence(:username) { |n| "username#{n}" }
    end

    trait :admin do
      role :admin
      sequence(:email) { |n| "admin#{n}@email.com" }
      sequence(:username) { |n| "admin#{n}" }
    end

    trait :moderator do
      role :moderator
      sequence(:email) { |n| "moderator#{n}@email.com" }
      sequence(:username) { |n| "moderator#{n}" }
    end

  end
end
