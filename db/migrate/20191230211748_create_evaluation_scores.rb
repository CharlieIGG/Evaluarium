# frozen_string_literal: true

class CreateEvaluationScores < ActiveRecord::Migration[6.0]
  def change
    create_table :evaluation_scores do |t|
      t.references :program_criterium, null: false, foreign_key: true
      t.references :project_evaluation, null: false, foreign_key: true
      t.float :total, null: false, default: 0.0
      t.float :weighed_total, null: false, default: 0.0

      t.timestamps
    end
  end
end
