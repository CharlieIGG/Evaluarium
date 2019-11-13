# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :project_program_summaries
  has_many :evaluation_programs, through: :project_program_summaries
end
