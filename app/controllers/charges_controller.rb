class ChargesController < ApplicationController
  require 'check_accounts'

  def new
    @amount = params[:amount]

    render layout: "portfolios"
  end
  
  def create
    # Amount in cents
    @amount = (params[:amount].to_i * 100)
  
    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )
  
    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'aud'
    )

    credit_card_balance = retrieve_balance(account_id("Credit card"))
    cash_balance = retrieve_balance(account_id("Cash"))
    credit_card_closing_balance = credit_card_balance - @amount
    cash_closing_balance = cash_balance + @amount
    Transaction.create!([
      {
        amount: @amount,
        from_account_id: account_id("Credit card")[0],
        to_account_id: account_id("Cash")[0],
        from_account_balance: credit_card_closing_balance,
        to_account_balance: cash_closing_balance,
        transaction_type: "principal"
      }
    ])
    
    render layout: "portfolios"

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

end
