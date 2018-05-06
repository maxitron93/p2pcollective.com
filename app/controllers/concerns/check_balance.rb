# require 'check_accounts'

# def check_loan_balance_outstanding(active_loan, investments)
#   opening_balance = active_loan.opening_balance.to_f

#   total_amount_invested = 0
#   investments.each do |investment|
#     total_amount_invested += investment.opening_balance.to_f
#   end

#   if total_amount_invested < opening_balance
#     puts "Do nothing"
#   elsif total_amount_invested == opening_balance
#     investments.each do |investment|
#       user_id = investment.user_id
#       Transaction.create!([
#         {
#           amount: investment.opening_balance,
#           from_account_id: Account.where(user_id: investment.user_id).where(label: "Pending investments").first.id,
#           to_account_id: Account.where(user_id: investment.user_id).where(label: "Active investments").first.id,
#           from_account_balance: (retrieve_balance(Account.where(user_id: investment.user_id).where(label: "Pending investments").first.id).to_i - (investment.opening_balance)),
#           to_account_balance: (retrieve_balance(Account.where(user_id: investment.user_id).where(label: "Active investments").first.id).to_i + (investment.opening_balance)),
#           transaction_type: "principal"
#         }
#       ])
#     end
#   end

# end