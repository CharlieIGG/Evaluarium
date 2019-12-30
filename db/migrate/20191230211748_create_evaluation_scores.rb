# frozen_string_literal: true

class CreateEvaluationScores < ActiveRecord::Migration[6.0]
  def change
    create_table :evaluation_scores do |t|
      t.references :evaluation_criterium, null: false, foreign_key: true
      t.references :project_evaluation_summary, null: false, foreign_key: true
      t.float :total

      t.timestamps
    end
  end
end
