class EmployeesController < ApplicationController
  require 'repayment_calculator'
  
  def awaiting_assessment
    @loan_applications = LoanApplication.where(status: "being assessed")
  end

  def assess_application
    @loan_application = LoanApplication.find(params[:id])
  end

  def approve_application
    loan = LoanApplication.find(params[:id])
    loan.status = "assessed"
    
    
    annual_basis_points = rand(600..900)

    ActiveLoan.create!([
      {
        user_id: loan.user_id,
        status: "pending approval",
        opening_balance: loan.loan_amount,
        loan_term: loan.loan_term,
        purpose: loan.purpose,
        category: LoanCategory.find(loan.loan_category_id).label,
        interest_rate: (annual_basis_points.to_f / 100).round(2),
        periodic_repayment_amount: calculate_monthly_repayment(loan.loan_amount, loan.loan_term, annual_basis_points).round(2),
        repayment_capacity: (loan.weekly_income - loan.weekly_expenses),
        employment_type: EmploymentType.find(loan.employment_type_id).label,
        work_gap_months: loan.work_gap_months
      }
    ])

    if loan.save!
      redirect_to awaiting_assessment_path, notice: 'Loan application successfully approved'
    else
      redirect_to awaiting_assessment_path, notice: 'Error please try again'
    end
  end
end
