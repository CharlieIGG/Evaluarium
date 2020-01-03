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
