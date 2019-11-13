# frozen_string_literal: true

class EvaluationProgram < ApplicationRecord
  has_many :project_program_summaries
  has_many :projects, through: :project_program_summaries
end
