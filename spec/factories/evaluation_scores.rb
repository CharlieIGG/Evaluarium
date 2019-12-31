# frozen_string_literal: true

# == Schema Information
#
# Table name: evaluation_scores
#
#  id                            :bigint           not null, primary key
#  evaluation_criterium_id       :bigint           not null
#  project_evaluation_summary_id :bigint           not null
#  total                         :float
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#


FactoryBot.define do
  factory :evaluation_score do
    evaluation_criterium
    project_evaluation_summary
    total { 75 }
  end
end
