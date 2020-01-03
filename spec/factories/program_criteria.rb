# frozen_string_literal: true

# == Schema Information
#
# Table name: program_criteria
#
#  id                      :bigint           not null, primary key
#  evaluation_program_id   :bigint           not null
#  evaluation_criterium_id :bigint           not null
#  position                :integer
#  weight                  :float
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

FactoryBot.define do
  factory :program_criterium do
    transient do
      maximum { 5 }
    end
    evaluation_program { create(:evaluation_program, criteria_scale_max: maximum) }
    evaluation_criterium
    position { 1 }
    weight { 10 }
  end
end
