class ProjectProgramSummary < ApplicationRecord
  belongs_to :evaluation_program
  belongs_to :project
end
