# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectProgramSummary, type: :model do
  subject { create(:project_program_summary) }

  it { should belong_to(:project) }
  it { should belong_to(:evaluation_program) }
  it { should have_many(:project_evaluations) }
  it { should validate_uniqueness_of(:project_id).scoped_to(:evaluation_program_id) }
  it do
    should(validate_numericality_of(:average_score)
              .is_less_than_or_equal_to(EvaluationProgram::MAXIMUM_VALID_SCORE)
              .is_greater_than_or_equal_to(0))
  end
end
