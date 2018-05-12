class EmployeesController < ApplicationController
  require 'repayment_calculator'
  require 'check_login'
  before_action :require_login
    
  def awaiting_assessment
    @loan_applications = LoanApplication.where(status: "being assessed")

    render layout: "employees" 
  end

  def assess_application
    @loan_application = LoanApplication.find(params[:id])

    render layout: "employees"
  end
end