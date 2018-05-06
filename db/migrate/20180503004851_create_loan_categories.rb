class CreateLoanCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_categories do |t|
      t.string :label

      t.timestamps
    end
  end
end
