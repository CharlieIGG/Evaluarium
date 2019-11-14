# frozen_string_literal: true

#
# This class depicts the track record for a Project in any given EvaluationProgram
#
class ProjectProgramSummary < ApplicationRecord
  belongs_to :evaluation_program
  belongs_to :project
  has_many :program_criteria, through: :evaluation_program
end
