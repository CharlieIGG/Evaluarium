# frozen_string_literal: true

FactoryBot.define do
  factory :evaluation_score do
    evaluation_criterium { nil }
    project_evaluation_summary { nil }
    total { 1.5 }
  end
end
