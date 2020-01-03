# frozen_string_literal: true

#
# This class manages the logic behind determining how a Summary's scores (JSONB) should
# be updated, and then performs the update.
#
class ProjectProgramSummaryUpdater
  PROGRAM_TYPE_METHODS = {
    project_follow_up: :take_latest_scores,
    competition: :take_average_scores
  }.freeze

  def initialize(project_id, evaluation_program_id)
    @summary = ProjectProgramSummary.find_by(
      project_id: project_id, evaluation_program_id: evaluation_program_id
    )
    return unless @summary

    @type = @summary.program_type
  end

  def run
    update_summary_scores
    update_total_score
  end

  private

  def update_summary_scores; end

  def update_total_score; end

  def scores
    send(PROGRAM_TYPE_METHODS[@type])
  end

  def take_latest_score
    @summary.evaluation_scores
  end

  def take_average_scores; end
end
