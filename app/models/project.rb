# frozen_string_literal: true

#
# Projects to evaluate, these might be Startups or something similar
#
class Project < ApplicationRecord
  has_many :project_program_summaries
  has_many :evaluation_programs, through: :project_program_summaries
end
