class AddStatusToLoanApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :loan_applications, :status, :string
  end
end
