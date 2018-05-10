def check_status
  status = LoanApplication.find(params[:id]).status
  if status == "being assessed" || status == "assessed"
    redirect_to my_loan_applications_path, notice: "You cannot make changes to that application."
  end
end