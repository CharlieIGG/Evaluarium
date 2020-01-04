# frozen_string_literal: true

class CreateEvaluationPrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :evaluation_programs do |t|
      t.string :name, null: false
      t.datetime :start_at, null: false, default: -> { 'NOW()' }
      t.datetime :end_at
      t.integer :program_type, null: false, default: 0

      t.timestamps
    end
  end
end
