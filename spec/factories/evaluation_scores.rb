# frozen_string_literal: true

# == Schema Information
#
# Table name: evaluation_scores
#
#  id                            :bigint           not null, primary key
#  program_criterium_id          :bigint           not null
#  project_evaluation_id :bigint           not null
#  total                         :float
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#


FactoryBot.define do
  factory :evaluation_score do
    program_criterium
    project_evaluation
    total { 5 }
  end
end
