# frozen_string_literal: true

# == Schema Information
#
# Table name: project_evaluations
#
#  id                    :bigint           not null, primary key
#  total_score           :float            default(0.0)
#  evaluation_program_id :bigint           not null
#  project_id            :bigint           not null
#  program_start         :date
#  evaluator_id          :bigint           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  timestamp             :datetime
#  scores                :jsonb
#

require 'rails_helper'

RSpec.describe ProjectEvaluation, type: :model do
  subject { create(:project_evaluation) }

  it { should belong_to(:project) }
  it { should belong_to(:evaluation_program) }
  it { should have_many(:evaluation_scores) }
  it do
    should(validate_numericality_of(:total_score)
              .is_less_than_or_equal_to(EvaluationProgram::MAXIMUM_VALID_SCORE)
              .is_greater_than_or_equal_to(0))
  end

  context 'validating evaluator uniqueness' do
    it 'should NOT enforce uniqueness if the EvaluationProgram is a "project follow up"' do
      clone = subject.dup
      expect(clone).to be_valid
    end

    it 'should enforce uniqueness if the EvaluationProgram is a "competition"' do
      subject.evaluation_program.update(program_type: :competition)
      clone = subject.dup
      expect(clone).not_to be_valid
    end
  end
end
