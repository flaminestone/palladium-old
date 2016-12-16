class CreateCustomFields < ActiveRecord::Migration[5.0]
  def change
    create_table :custom_fields do |t|
      t.text :name
      t.text :description
      t.text :type
      t.text :default
      t.timestamps
    end
  end
end
