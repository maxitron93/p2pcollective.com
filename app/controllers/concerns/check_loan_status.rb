def check_status
  status = LoanApplication.find(params[:id]).status
  if status == "being assessed"
    redirect_to my_loan_applications_path, notice: "That application is currently being assessed."
  end
end