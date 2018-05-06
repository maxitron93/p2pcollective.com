class AddColumnsToActiveLoan < ActiveRecord::Migration[5.1]
  def change
    add_column :active_loans, :category, :string
    add_column :active_loans, :interest_rate, :decimal
    add_column :active_loans, :periodic_repayment_amount, :decimal
    add_column :active_loans, :repayment_capacity, :decimal
    add_column :active_loans, :employment_type, :string
    add_column :active_loans, :work_gap_months, :integer
  end
end