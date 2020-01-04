# frozen_string_literal: true

#
# This class manages the logic behind determining how a Summary's scores (JSONB) should
# be updated, and then performs the update.
#
class ProjectProgramSummaryUpdater
  PROGRAM_TYPE_METHODS = {
    project_follow_up: :take_latest_evaluation,
    competition: :take_all_evaluations
  }.with_indifferent_access

  def initialize(project_id, evaluation_program_id)
    @summary = ProjectProgramSummary.find_by(
      project_id: project_id, evaluation_program_id: evaluation_program_id
    )
    return unless @summary

    @type = @summary.program_type
  end

  def run
    assign_summary_scores
    assign_average_score
    @summary.save!
  end

  private

  def assign_summary_scores
    @summary.scores_summary['evaluation_count'] = evaluations.count
    @summary.scores_summary['criteria'] = generate_criteria_summary
  end

  def assign_average_score
    @summary.average_score = evaluations.average(:total_score)
  end

  def evaluations
    @evaluations ||= send(PROGRAM_TYPE_METHODS[@type])
  end

  def take_latest_evaluation
    @summary.project_evaluations.order(timestamp: :desc).limit(1)
  end

  def take_all_evaluations
    @summary.project_evaluations
  end

  def generate_criteria_summary
    sql = <<-SQL
      SELECT
        evaluation_criteria.name,
        program_criteria.weight,
        evaluation_programs.criteria_scale_max AS maximum,
        evaluation_programs.criteria_scale_min AS minimum,
        AVG(evaluation_scores.total) AS total,
        AVG(evaluation_scores.weighed_total) AS weighed_total
      FROM evaluation_scores
      LEFT JOIN program_criteria
        ON evaluation_scores.program_criterium_id =  program_criteria.id
      LEFT JOIN evaluation_programs
        ON program_criteria.evaluation_program_id = evaluation_programs.id
      LEFT JOIN evaluation_criteria
        ON program_criteria.evaluation_criterium_id = evaluation_criteria.id
      WHERE evaluation_scores.project_evaluation_id IN (#{evaluations.pluck(:id).join(', ')})
      GROUP BY
        evaluation_criteria.name, program_criteria.weight,
        evaluation_programs.criteria_scale_max,
        evaluation_programs.criteria_scale_min
      ORDER BY
        evaluation_criteria.name
    SQL
    scores = EvaluationScore.connection.execute(sql).to_a
    scores.inject({}) { |hash, score| hash.merge(score['name'] => score) }
  end
end
