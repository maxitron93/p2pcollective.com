class AddRepaymentAmountColumnToInvestment < ActiveRecord::Migration[5.1]
  def change
    add_column :investments, :repayment_amount, :decimal
  end
end
