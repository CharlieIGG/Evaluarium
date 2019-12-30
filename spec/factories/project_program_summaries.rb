# == Schema Information
#
# Table name: project_evaluation_summaries
#
#  id                    :bigint           not null, primary key
#  average               :float
#  evaluation_program_id :bigint           not null
#  project_id            :bigint           not null
#  program_start         :date
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

FactoryBot.define do
  factory :project_evaluation_summary do
    average { 1.5 }
    evaluation_program { nil }
    project { nil }
    program_start { "2019-11-13" }
  end
end
