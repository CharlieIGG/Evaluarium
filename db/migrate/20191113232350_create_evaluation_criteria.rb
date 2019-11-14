class CreateEvaluationCriteria < ActiveRecord::Migration[6.0]
  def change
    create_table :evaluation_criteria do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
