FactoryGirl.define do
  factory :pet do
    sequence(:name) { |n| "name#{n}" }
    user
  end

  factory :user do
    sequence(:first_name) { |n| "first_name#{n}" }
    email { "#{first_name}@example.com" }
  end
end
