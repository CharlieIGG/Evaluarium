# frozen_string_literal: true

# == Schema Information
#
# Table name: project_evaluation_summaries
#
#  id                    :bigint           not null, primary key
#  total_score           :float            default(0.0)
#  evaluation_program_id :bigint           not null
#  project_id            :bigint           not null
#  program_start         :date
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  timestamp             :datetime
#  scores                :jsonb
#


#
# This class depicts the track record for a Project in any given EvaluationProgram
#
class ProjectEvaluationSummary < ApplicationRecord
  belongs_to :evaluation_program
  belongs_to :project
  has_many :evaluation_scores

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
end
