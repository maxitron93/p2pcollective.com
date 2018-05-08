class EmployeesController < ApplicationController
  require 'repayment_calculator'
  
  def awaiting_assessment
    @loan_applications = LoanApplication.where(status: "being assessed")

    render layout: "employees" 
  end

  def assess_application
    @loan_application = LoanApplication.find(params[:id])

    render layout: "employees"
  end
end
