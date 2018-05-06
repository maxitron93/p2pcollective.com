class CreateRepayments < ActiveRecord::Migration[5.1]
  def change
    create_table :repayments do |t|
      t.references :active_loan, foreign_key: true
      t.references :investment, foreign_key: true
      t.decimal :amount

      t.timestamps
    end
  end
end
