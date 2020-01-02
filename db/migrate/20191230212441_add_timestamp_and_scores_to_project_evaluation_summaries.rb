# frozen_string_literal: true

class AddTimestampAndScoresToProjectEvaluationSummaries < ActiveRecord::Migration[6.0]
  def change
    add_column :project_evaluations, :timestamp, :datetime
  end
end
