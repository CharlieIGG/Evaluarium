FactoryBot.define do
  factory :project_program_summary do
    average { 1.5 }
    evaluation_program { nil }
    project { nil }
    program_start { "2019-11-13" }
  end
end
