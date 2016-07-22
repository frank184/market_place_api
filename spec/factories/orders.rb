FactoryGirl.define do
  factory :order do
    total { Faker::Commerce.price }
  end
end
