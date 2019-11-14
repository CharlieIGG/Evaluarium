# frozen_string_literal: true

#
# This is an "instance" of an EvaluationCriteria scoped to a specific
# evaluation program. Each "instance" carries it's own position (order)
# and it's own weight, which will ultimately be used to calculate a total % in
# each Project's ProjectProgramSummary
#
class ProgramCriterium < ApplicationRecord
  belongs_to :evaluation_program
  belongs_to :evaluation_criterium
  has_many :project_program_summaries, -> { distinct }, through: :evaluation_program
end
