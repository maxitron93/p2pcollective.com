def compare_user_id
  if current_user.id != LoanApplication.find(params[:id].to_i).user_id
    redirect_to my_loan_applications_path, notice: "You do not have access to that application"
  end  
end

def check_account_ids
  account_ids = current_user.accounts.ids
  # account_ids = User.find(id: current_user.id).accounts.ids
  check_result = false
  account_ids.each do |id|
    if id == params[:id].to_i
      check_result = true
    end
  end
  
  if check_result == false
    redirect_to root_path, notice: "You do not have access to that account"
  end
end
