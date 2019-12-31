# frozen_string_literal: true

# == Schema Information
#
# Table name: evaluation_programs
#
#  id         :bigint           not null, primary key
#  name       :string
#  start_at   :datetime
#  end_at     :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :evaluation_program do
    sequence(:name) { |n| "Program #{n}" }
    start_at { '2019-11-13 01:04:14' }
    end_at { '2019-11-13 01:04:14' }
  end
end
