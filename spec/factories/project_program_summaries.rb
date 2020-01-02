# frozen_string_literal: true

# == Schema Information
#
# Table name: project_evaluation_summaries
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
  factory :project_evaluation_summary do
    total_score { 0 }
    evaluation_program
    project
    program_start { '2019-11-13' }
    evaluator { create(:user) }
  end
end
