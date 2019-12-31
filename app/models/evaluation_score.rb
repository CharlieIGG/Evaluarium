# frozen_string_literal: true

# == Schema Information
#
# Table name: evaluation_scores
#
#  id                            :bigint           not null, primary key
#  evaluation_criterium_id       :bigint           not null
#  project_evaluation_summary_id :bigint           not null
#  total                         :float
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

#
# An EvaluationScore is a score for a specific Project (via the EvaluationSummary),
# and a specific Evaluation.
#
class EvaluationScore < ApplicationRecord
  belongs_to :evaluation_criterium
  belongs_to :project_evaluation_summary

  delegate :name, to: :evaluation_criterium

  validates :evaluation_criterium_id, uniqueness: { scope: :project_evaluation_summary_id }
  validates_numericality_of :total, greater_than_or_equal_to: 0, less_than_or_equal_to: 100

  after_commit :update_summary!
  after_destroy :update_summary!

  def update_summary!
    project_evaluation_summary.recalculate_average
    scores_total = persisted? ? total : nil
    project_evaluation_summary.scores[evaluation_criterium.name] = scores_total
    project_evaluation_summary.save
  end
end
