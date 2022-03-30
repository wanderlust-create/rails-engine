# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence(word_count: 3) }
    unit_price { Faker::Commerce.price(range: 0..17.99) }
    association :merchant, factory: :merchant
  end
end
