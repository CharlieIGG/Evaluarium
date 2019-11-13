# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence (:email) { |n| "#{n}_#{FFaker::Internet.email}" }
    password { '12345678' }
    password_confirmation { '12345678' }
    created_at { Date.today }
  end
end
