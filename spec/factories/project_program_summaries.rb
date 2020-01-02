# frozen_string_literal: true

FactoryBot.define do
  factory :project_program_summary do
    average_score { 3 }
    latest_increase_percent { 1.5 }
    evaluation_program
    project
  end
end
