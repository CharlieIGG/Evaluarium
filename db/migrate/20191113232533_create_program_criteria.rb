# frozen_string_literal: true

class CreateProgramCriteria < ActiveRecord::Migration[6.0]
  def change
    create_table :program_criteria do |t|
      t.references :evaluation_program, null: false, foreign_key: true
      t.references :evaluation_criterium, null: false, foreign_key: true
      t.integer :position
      t.float :weight

      t.timestamps
    end
  end
end
