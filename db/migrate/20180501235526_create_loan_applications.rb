class CreateLoanApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_applications do |t|
      t.references :user, foreign_key: true
      t.decimal :loan_amount
      t.integer :loan_term
      t.text :purpose

      t.timestamps
    end
  end
end
