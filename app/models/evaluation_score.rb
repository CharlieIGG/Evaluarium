# frozen_string_literal: true

# == Schema Information
#
# Table name: evaluation_scores
#
#  id                            :bigint           not null, primary key
#  program_criterium_id          :bigint           not null
#  project_evaluation_id :bigint           not null
#  total                         :float
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

#
# An EvaluationScore is a score for a specific Project (via the EvaluationSummary),
# and a specific Evaluation.
#
class EvaluationScore < ApplicationRecord
  belongs_to :program_criterium
  belongs_to :project_evaluation
  has_one :evaluation_program, through: :program_criterium
  delegate :name, :weight, to: :program_criterium

  validates :program_criterium_id, uniqueness: { scope: :project_evaluation_id }
  validates_with EvaluationScoreValidator

  def minimum
    evaluation_program.criteria_scale_min
  end

  def maximum
    evaluation_program.criteria_scale_max
  end

  def score_summary
    points = persisted? ? total : nil
    {
      "points": points,
      "scale": { "min": minimum, "max": maximum },
      "weight": weight,
      "weight_type": 'percentage',
      "weighed_points": (points.to_f / maximum) * weight
    }.with_indifferent_access
  end
end
