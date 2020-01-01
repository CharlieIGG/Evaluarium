# frozen_string_literal: true

# == Schema Information
#
# Table name: project_evaluation_summaries
#
#  id                    :bigint           not null, primary key
#  total_score           :float            default(0.0)
#  evaluation_program_id :bigint           not null
#  project_id            :bigint           not null
#  program_start         :date
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  timestamp             :datetime
#  scores                :jsonb
#


require 'rails_helper'

RSpec.describe ProjectEvaluationSummary, type: :model do
  subject { build_stubbed(:project_evaluation_summary) }

  it { should belong_to(:project) }
  it { should belong_to(:evaluation_program) }
  it { should have_many(:evaluation_scores) }
  it do
    should(validate_numericality_of(:total_score)
              .is_less_than_or_equal_to(EvaluationProgram::MAXIMUM_VALID_SCORE)
              .is_greater_than_or_equal_to(0))
  end
end
