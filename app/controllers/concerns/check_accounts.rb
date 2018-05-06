# Retrieve the account id of the specified user and account label
def account_id(label)
  current_user.accounts.where(label: label).ids
end

# Retrieve account balances by calculating all associated transactions
def retrieve_balance(acc_id)
  deducting_transactions = Transaction.where(from_account_id: acc_id).pluck(:amount)
  adding_transactions = Transaction.where(to_account_id: acc_id).pluck(:amount)

  deductions = 0
  deducting_transactions.each do |transaction|
    deductions += transaction
  end

  additions = 0
  adding_transactions.each do |transaction|
    additions += transaction
  end

  return(additions - deductions)
end

# Check if current_user has any transactions with that account label
def transactions_exist(account_label)
  return_value = false
  check_account_id = current_user.accounts.where(label: account_label).ids[0]
  if Transaction.where(from_account_id: check_account_id).exists? || Transaction.where(to_account_id: check_account_id).exists?
    return_value = true
  end
  return return_value
end