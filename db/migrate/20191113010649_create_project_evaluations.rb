# frozen_string_literal: true

class CreateProjectEvaluations < ActiveRecord::Migration[6.0]
  def change
    create_table :project_evaluations do |t|
      t.float :total_score, default: 0.0
      t.references :evaluation_program, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.references :evaluator, index: true, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
