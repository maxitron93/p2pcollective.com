class CreateInvestments < ActiveRecord::Migration[5.1]
  def change
    create_table :investments do |t|
      t.references :active_loan, foreign_key: true
      t.references :user, foreign_key: true
      t.decimal :opening_balance

      t.timestamps
    end
  end
end
