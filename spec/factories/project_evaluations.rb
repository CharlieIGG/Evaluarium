# frozen_string_literal: true

# == Schema Information
#
# Table name: project_evaluations
#
#  id                    :bigint           not null, primary key
#  total_score           :float            default(0.0)
#  evaluation_program_id :bigint           not null
#  project_id            :bigint           not null
#  evaluator_id          :bigint           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  timestamp             :datetime
#

FactoryBot.define do
  factory :project_evaluation do
    transient do
      score_count { 5 }
    end

    total_score { 0 }
    evaluation_program
    project
    evaluator { create(:user) }

    trait :with_homogeneous_scores do
      after(:create) do |evaluation, transients|
        program = evaluation.evaluation_program
        create_list(:evaluation_score, transients.score_count,
                    project_evaluation: evaluation,
                    evaluation_program: program, criterium_weight: 100 / transients.score_count,
                    total: evaluation.total_score * program.criteria_scale_max / 100)
      end
    end
  end
end
