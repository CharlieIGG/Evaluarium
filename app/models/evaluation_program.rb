# frozen_string_literal: true

#
# A wrapper for evaluations. A project (Startup) might be part of several
# EvaluationPrograms, some lasting hours, some lasting months, and each with different evaluators
#
class EvaluationProgram < ApplicationRecord
  has_many :project_program_summaries
  has_many :program_criteria
  has_many :projects, through: :project_program_summaries
  has_many :evaluation_criteria, through: :program_criteria
end
