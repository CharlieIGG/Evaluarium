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

class ProjectProgramSummary < ApplicationRecord
  belongs_to :evaluation_program
  belongs_to :project

  validates :project_id, uniqueness: { scope: :evaluation_program_id }
  validates_numericality_of :average_score,
                            less_than_or_equal_to: EvaluationProgram::MAXIMUM_VALID_SCORE,
                            greater_than_or_equal_to: 0

  delegate :program_type, to: :evaluation_program

  def project_evaluations
    project.project_evaluations.where(
      evaluation_program_id: evaluation_program.id
    )
  end
end
