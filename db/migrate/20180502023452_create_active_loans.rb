class CreateActiveLoans < ActiveRecord::Migration[5.1]
  def change
    create_table :active_loans do |t|
      t.references :user, foreign_key: true
      t.string :status
      t.decimal :opening_balance
      t.integer :loan_term
      t.text :purpose

      t.timestamps
    end
  end
end
