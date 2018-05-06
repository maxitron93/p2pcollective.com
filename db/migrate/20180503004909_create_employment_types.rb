class CreateEmploymentTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :employment_types do |t|
      t.string :label

      t.timestamps
    end
  end
end
