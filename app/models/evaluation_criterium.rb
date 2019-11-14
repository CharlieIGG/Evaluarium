# frozen_string_literal: true

#
# This class is used to create the catalogue of different evaluation criteria
# that can later be added to an EvaluationProgram in order to evaluate Projects
#
class EvaluationCriterium < ApplicationRecord
  has_many :program_criteria
  has_many :evaluation_programs, -> { distinct }, through: :program_criteria
  has_many :project_program_summaries, -> { distinct }, through: :evaluation_programs
end
