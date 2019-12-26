# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :bigint
#  invitations_count      :integer          default(0)
#  name                   :string
#  phone                  :string
#  position               :string
#


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
