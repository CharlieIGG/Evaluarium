# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    transient do
      project_ids { [] }
      evaluation_program_ids { [] }
    end

    sequence (:email) { |n| "#{n}_#{FFaker::Internet.email}" }
    password { '12345678' }
    password_confirmation { '12345678' }
    created_at { Date.today }

    trait :superadmin do
      after :create do |user|
        user.add_role :superadmin
      end
    end
  end
end
