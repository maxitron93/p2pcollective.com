class AddColumnsToLoanApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :loan_applications, :first_name, :string
    add_column :loan_applications, :last_name, :string
    add_reference :loan_applications, :loan_category
    add_column :loan_applications, :street_address, :string
    add_column :loan_applications, :city, :string
    add_column :loan_applications, :state, :string
    add_column :loan_applications, :postcode, :integer
    add_reference :loan_applications, :employment_type
    add_column :loan_applications, :weekly_income, :decimal
    add_column :loan_applications, :weekly_expenses, :decimal
    add_column :loan_applications, :work_gap_months, :integer
    add_column :loan_applications, :pay_slip_data, :text
    add_column :loan_applications, :license_data, :text
  end
end