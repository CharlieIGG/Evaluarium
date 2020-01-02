# frozen_string_literal: true

class CreateProjectEvaluationSummaries < ActiveRecord::Migration[6.0]
  def change
    create_table :project_evaluation_summaries do |t|
      t.float :total_score, default: 0.0
      t.references :evaluation_program, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.date :program_start
      t.references :evaluator, index: true, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
