# frozen_string_literal: true

# == Schema Information
#
# Table name: project_program_summaries
#
#  id                      :bigint           not null, primary key
#  average_score           :float            default(0.0), not null
#  latest_increase_percent :float
#  evaluation_program_id   :bigint           not null
#  project_id              :bigint           not null
#  scores_summary          :jsonb            not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#


FactoryBot.define do
  factory :project_program_summary do
    average_score { 3 }
    latest_increase_percent { 1.5 }
    evaluation_program
    project
    scores_summary { {} }
  end
end
