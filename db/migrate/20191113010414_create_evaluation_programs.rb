# frozen_string_literal: true

class CreateEvaluationPrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :evaluation_programs do |t|
      t.string :name, null: false
      t.datetime :start_at, null: false, default: -> { 'NOW()' }
      t.datetime :end_at
      t.integer :program_type, null: false, default: 0
      t.integer :score_calculation_method, null: false
      t.integer :calculation_inclusion_count
      t.integer :calculation_inclusion_unit

      t.timestamps
    end
  end
end
