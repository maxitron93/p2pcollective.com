class PortfoliosController < ApplicationController
  
  require 'check_accounts'

  # Home page for all users that are logged in
  def all

    # Checks existing transactions and retrieve the user's account balances that need to be displayed 
    @cash_balance = retrieve_balance(account_id("Cash"))/100
    @cash_account_id = account_id("Cash")

    @active_investments_balance = retrieve_balance(account_id("Active investments"))/100
    @active_investments_acocunt_id = account_id("Active investments")

    @pending_investments_balance = retrieve_balance(account_id("Pending investments"))/100
    @pending_investments_account_id = account_id("Pending investments")

    @distressed_investments_exists = transactions_exist("Distressed investments")
    @distressed_investments = retrieve_balance(account_id("Distressed investments"))/100
    @distressed_investments_account_id = account_id("Distressed investments")

    @outstanding_loans = retrieve_balance(account_id("Outstanding loans"))/100
    @outstanding_loans_account_id = account_id("Outstanding loans")

    @defaulted_loans_exists = transactions_exist("Defaulted loans")
    @defaulted_loans = retrieve_balance(account_id("Defaulted loans"))/100
    @defaulted_loans_account_id = account_id("Defaulted loans")

    # Render layout from views/layouts/portfolios.html.erb
    render layout: "portfolios"
  end

  def add_cash

    render layout: "portfolios"
  end

  def withdraw_cash

    render layout: "portfolios"
  end

  def withdraw_confirmation
    @amount = params[:amount]
    
    if @amount.to_i <= retrieve_balance(account_id("Cash"))/100
      Transaction.create!([
        amount: @amount.to_i * 100,
        from_account_id: account_id("Cash")[0],
        to_account_id: account_id("Bank account")[0],
        from_account_balance: (retrieve_balance(account_id("Cash")).to_i - (@amount.to_i * 100)),
        to_account_balance: (retrieve_balance(account_id("Bank account")).to_i + (@amount.to_i * 100)),
        transaction_type: "principal"
      ])
    else
      redirect_to withdraw_cash_path, notice: "You do not have enough cash in your account to withdraw $#{@amount}."
    end

  end


  def account_history
    @acc_id = params[:id]
    unordered_transactions = Transaction.where(from_account_id: params[:id]).or(Transaction.where(to_account_id: params[:id]))
    @transactions = unordered_transactions.order('created_at DESC')

    @acc_name = Account.find(params[:id]).label
    render layout: "portfolios"
  end

  def my_loan_applications
    
    
    render layout: "portfolios"
  end

end
