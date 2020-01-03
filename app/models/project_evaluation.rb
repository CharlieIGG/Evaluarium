# frozen_string_literal: true

# == Schema Information
#
# Table name: project_evaluations
#
#  id                    :bigint           not null, primary key
#  total_score           :float            default(0.0)
#  evaluation_program_id :bigint           not null
#  project_id            :bigint           not null
#  evaluator_id          :bigint           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  timestamp             :datetime
#

#
# This class depicts the track record for a Project in any given EvaluationProgram
#
class ProjectEvaluation < ApplicationRecord
  belongs_to :evaluation_program
  belongs_to :project
  belongs_to :evaluator, class_name: 'User'
  has_many :evaluation_scores

  validates :evaluator_id, uniqueness: { scope: :evaluation_program_id },
                           if: :enforce_evaluator_uniqueness?
  validates_numericality_of :total_score,
                            less_than_or_equal_to: EvaluationProgram::MAXIMUM_VALID_SCORE,
                            greater_than_or_equal_to: 0

  def recalculate_total_score
    self.total_score = calculate_total_score
    total_score
  end

  def recalculate_total_score!
    update(total_score: recalculate_total_score)
  end

  def calculate_total_score
    return 0 unless scores.count.positive?

    scores.map { |_k, score| score[:weighed_points] }.compact.sum
  end

  def enforce_evaluator_uniqueness?
    return false unless evaluation_program.present?

    evaluation_program.competition?
end
end
