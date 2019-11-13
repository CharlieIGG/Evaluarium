class CreateProjectProgramSummaries < ActiveRecord::Migration[6.0]
  def change
    create_table :project_program_summaries do |t|
      t.float :average
      t.references :evaluation_program, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.date :program_start

      t.timestamps
    end
  end
end
