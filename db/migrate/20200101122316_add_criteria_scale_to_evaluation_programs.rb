# frozen_string_literal: true

class AddCriteriaScaleToEvaluationPrograms < ActiveRecord::Migration[6.0]
  def change
    add_column :evaluation_programs, :criteria_scale_max, :float, null: false
    add_column :evaluation_programs, :criteria_scale_min, :float, null: false
    add_column :evaluation_programs, :criteria_step_size, :float, null: false, default: 1.0
  end
end
