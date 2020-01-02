# frozen_string_literal: true

# == Schema Information
#
# Table name: project_evaluations
#
#  id                    :bigint           not null, primary key
#  total_score            :float
#  evaluation_program_id :bigint           not null
#  project_id            :bigint           not null
#  program_start         :date
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

FactoryBot.define do
  factory :project_evaluation do
    transient do
      custom_program { create(:evaluation_program) }
      custom_project { create(:project) }
    end

    total_score { 0 }
    evaluation_program { custom_program }
    project { custom_project }
    evaluator { create(:user) }

    trait :with_homogeneous_scores do
    end
  end
end
