# frozen_string_literal: true

class EvaluationScore < ApplicationRecord
  belongs_to :evaluation_criterium
  belongs_to :project_evaluation_summary
end
