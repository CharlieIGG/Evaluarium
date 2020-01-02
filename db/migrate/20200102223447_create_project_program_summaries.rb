# frozen_string_literal: true

class CreateProjectProgramSummaries < ActiveRecord::Migration[6.0]
  def change
    create_table :project_program_summaries do |t|
      t.float :average_score, null: false, default: 0.0
      t.float :latest_increase_percent
      t.references :evaluation_program, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.jsonb :scores_summary, null: false, default: {}

      t.timestamps
    end
  end
end
