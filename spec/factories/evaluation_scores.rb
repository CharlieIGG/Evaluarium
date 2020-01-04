# frozen_string_literal: true

# == Schema Information
#
# Table name: evaluation_scores
#
#  id                    :bigint           not null, primary key
#  program_criterium_id  :bigint           not null
#  project_evaluation_id :bigint           not null
#  total                 :float            default(0.0), not null
#  weighed_total         :float            default(0.0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#


FactoryBot.define do
  factory :evaluation_score do
    transient do
      evaluation_program { create(:evaluation_program) }
      criterium_weight { 10 }
    end
    program_criterium { create(:program_criterium, evaluation_program: evaluation_program, weight: criterium_weight) }
    project_evaluation { create(:project_evaluation, evaluation_program: evaluation_program) }
    total { 5 }
  end
end
