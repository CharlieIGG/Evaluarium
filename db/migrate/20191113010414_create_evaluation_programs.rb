class CreateEvaluationPrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :evaluation_programs do |t|
      t.string :name
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
