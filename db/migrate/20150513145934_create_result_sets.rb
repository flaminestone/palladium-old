class CreateResultSets < ActiveRecord::Migration
  def change
    create_table :result_sets do |t|
      t.string :name
      t.string :date
      t.string :version
      t.string :status
      t.integer :run_id
      t.integer :plan_id
      t.timestamps null: false
    end
  end
end
