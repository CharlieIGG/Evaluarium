# frozen_string_literal: true

class AddTimestampAndScoresToProjectEvaluationSummaries < ActiveRecord::Migration[6.0]
  def change
    add_column :project_evaluation_summaries, :timestamp, :datetime
    add_column :project_evaluation_summaries, :scores, :jsonb, default: {}
  end
end
