class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.integer :from_account_id
      t.integer :to_account_id
      t.decimal :from_account_balance
      t.decimal :to_account_balance
      t.string :type

      t.timestamps
    end
  end
end
