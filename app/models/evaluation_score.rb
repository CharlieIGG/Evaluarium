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

  after_commit :update_summary!

  def update_summary!
    project_evaluation_summary.calculate_average
    project_evaluation_summary.scores[evaluation_criterium.name] = total
    project_evaluation_summary.save
  end
end
