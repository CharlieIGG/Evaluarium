# frozen_string_literal: true

class ProjectProgramSummary < ApplicationRecord
  belongs_to :evaluation_program
  belongs_to :project
  has_many :project_evaluations, -> { where(evaluation_program_id: evaluation_program_id) }, through: :project

  validates :project_id, uniqueness: { scope: :evaluation_program_id }
  validates_numericality_of :average_score,
                            less_than_or_equal_to: EvaluationProgram::MAXIMUM_VALID_SCORE,
                            greater_than_or_equal_to: 0

  delegate :program_type, to: :evaluation_program
end
