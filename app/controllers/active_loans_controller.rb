class ActiveLoansController < ApplicationController
  require 'check_accounts'

  def index
    @status = params[:status]

    @active_loans = ActiveLoan.where(status: params[:status])

    render layout: "portfolios"
  end

  def my_index
    @status = params[:status]
    
    @active_loans = ActiveLoan.where(user_id: current_user.id).where(status: params[:status])

    render layout: "portfolios"
  end

  def my_investments
    all_currnet_users_investments = Investment.where(user_id: current_user.id)
    @status = params[:status]
    @investments_by_status = []
    dummy_count = 0
    all_currnet_users_investments.each do |investment|
      if investment.active_loan.status == params[:status]
        @investments_by_status.push(investment)
      else
        dummy_count += 1
      end
    end

    
    
    render layout: "portfolios"
  end

  def approve
    loan = LoanApplication.find(params[:id])

    annual_basis_points = rand(600..900)

    ActiveLoan.create!([
      {
        user_id: loan.user_id,
        status: "unfunded",
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

    if loan.update(status: "assessed")
      redirect_to awaiting_assessment_path, notice: 'Loan application successfully approved. It is now live.'
    else
      redirect_to awaiting_assessment_path, notice: 'Error please try again.'
    end

  end

  def show
    @active_loan = ActiveLoan.find(params[:id])

    render layout: "portfolios"
  end

  def invest
    active_loan_id = params[:id].to_i
    investment_amount = (params[:investment_amount].to_f * 100)

    # Checks if the user has enough money in their Cash account to invest
    if (retrieve_balance(account_id("Cash")).to_f ) >= investment_amount
      
      # Checks if the new investment amount pushes the loan to become fully funded      
      # Calculate total invested in the loan so far
      amount_invested_so_far = 0.0
      relevant_investment_records = Investment.where(active_loan_id: active_loan_id)
      relevant_investment_records.each do |investment_record|
        amount_invested_so_far += investment_record.opening_balance.to_f
      end

      
      
      # If the new investment amount pushes the loan to become over funded, tells them so
      if (amount_invested_so_far + investment_amount) > ActiveLoan.find(active_loan_id).opening_balance.to_f
        redirect_to show_active_loan_path(id: active_loan_id), notice: "The borrower doesn't need that much. Please invest a lower amount"
        
      # Elsif the new investment amount pushes the loan to become 100% funded, execute required Logic
      elsif (amount_invested_so_far + investment_amount) == ActiveLoan.find(active_loan_id).opening_balance.to_f
        # Calculate the investor's share of borrower's monthly repayment obligation 
        percentage_of_loan_amount = (investment_amount * 100) / (ActiveLoan.find(active_loan_id).opening_balance.to_f)
        repayment_amount = ((ActiveLoan.find(active_loan_id).periodic_repayment_amount.to_f * percentage_of_loan_amount)).round(2)
        
        # Logic to create an investment record
        investment_details = ({
          active_loan_id: active_loan_id,
          user_id: current_user.id,
          opening_balance: investment_amount,
          repayment_amount: repayment_amount,
        })

        # Logic to transfer cash from cash account to pending investment
        investor_transaction_details = ({
          amount: investment_amount,
          from_account_id: Account.where(user_id: current_user.id).where(label: "Cash").first.id,
          to_account_id: Account.where(user_id: current_user.id).where(label: "Pending investments").first.id,
          from_account_balance: (retrieve_balance(account_id("Cash")).to_i - (investment_amount.to_i)),
          to_account_balance: (retrieve_balance(account_id("Pending investments")).to_i + (investment_amount.to_i)), 
          transaction_type: "principal"
        })
        
        if Investment.create!(investment_details) && Transaction.create!(investor_transaction_details) && 
          # Changes status of loan from unfunded to funded
          investments = Investment.where(active_loan_id: active_loan_id)

          # Create the transactions to move outstanding lonas into the cash account for the borrower
          lender_user_id = ActiveLoan.find(active_loan_id).user_id
          loan_amount = ActiveLoan.find(active_loan_id).opening_balance
          lender_outstanding_loans_account_id = Account.where(user_id: lender_user_id).where(label: "Outstanding loans").first.id
          lender_cash_account_id = Account.where(user_id: lender_user_id).where(label: "Cash").first.id
          lender_transaction_details = ({
          amount: loan_amount,
          from_account_id: lender_outstanding_loans_account_id,
          to_account_id: lender_cash_account_id,
          from_account_balance: (retrieve_balance(lender_outstanding_loans_account_id).to_i - loan_amount),
          to_account_balance: (retrieve_balance(lender_cash_account_id).to_i + loan_amount), 
          transaction_type: "principal"
          })
          Transaction.create!(lender_transaction_details)

          # Create the transactions to move pending investments into active investments for all investors
          investments.each do |investment|
          user_id = investment.user_id
          pending_investments_account_id = Account.where(user_id: investment.user_id).where(label: "Pending investments").first.id
          active_investments_account_id = Account.where(user_id: investment.user_id).where(label: "Active investments").first.id
          Transaction.create!([
            {
              amount: investment.opening_balance,
              from_account_id: pending_investments_account_id,
              to_account_id: active_investments_account_id,
              from_account_balance: (retrieve_balance(pending_investments_account_id).to_i - (investment.opening_balance)),
              to_account_balance: (retrieve_balance(active_investments_account_id).to_i + (investment.opening_balance)),
              transaction_type: "principal"
            }
          ])
          end

          ActiveLoan.find(active_loan_id).update(status: "funded")
          redirect_to root_path, notice: "You have invested $#{investment_amount / 100} to active loan #{active_loan_id}!" 
        else
          redirect_to show_active_loan_path(id: active_loan_id), notice: "Something went wrong. Please try again."
        end

        # Elsif the new investment amount doesn't pushes the loan to become 100% funded, execute required Logic
      elsif (amount_invested_so_far + investment_amount) < ActiveLoan.find(active_loan_id).opening_balance.to_f
        # Calculate the investor's share of borrower's monthly repayment obligation 
        percentage_of_loan_amount = (investment_amount * 100) / (ActiveLoan.find(active_loan_id).opening_balance.to_f)
        repayment_amount = ((ActiveLoan.find(active_loan_id).periodic_repayment_amount.to_f * percentage_of_loan_amount)).round(2)
        
        # Logic to create an investment record
        investment_details = ({
          active_loan_id: active_loan_id,
          user_id: current_user.id,
          opening_balance: investment_amount,
          repayment_amount: repayment_amount,
          })

        # Logic to transfer cash from cash account to pending investment
        transaction_details = ({
          amount: investment_amount,
          from_account_id: Account.where(user_id: current_user.id).where(label: "Cash").first.id,
          to_account_id: Account.where(user_id: current_user.id).where(label: "Pending investments").first.id,
          from_account_balance: (retrieve_balance(account_id("Cash")).to_i - (investment_amount.to_i)),
          to_account_balance: (retrieve_balance(account_id("Pending investments")).to_i + (investment_amount.to_i)), 
          transaction_type: "principal"
        })

        if Investment.create!(investment_details) && Transaction.create!(transaction_details)
          redirect_to root_path, notice: "You have committed $#{investment_amount / 100} to active loan #{active_loan_id}!" 
        else
          redirect_to show_active_loan_path(id: active_loan_id), notice: "Something went wrong. Please try again."
        end

      end
      
    else
      redirect_to root_path, notice: "You do not have enough in your Cash account to commit $#{investment_amount / 100} for investment."
    end

  end

  def repay_loan_confirmation
    active_loan_id = params[:id].to_i
    repayment_amount = (params[:repayment_amount].to_f * 100)
    
    # Checks if the user has enough money in their Cash account to invest
    if (retrieve_balance(account_id("Cash")).to_f ) >= repayment_amount

      # Checks if the new repayment amount pushes the loan to become fully repaid      
      # Calculate total repayments made to the loan so far
      amount_repaid_so_far = 0.0
      relevant_repayment_records = Repayment.where(active_loan_id: active_loan_id)
      relevant_repayment_records.each do |repayment_record|
        amount_repaid_so_far += repayment_record.amount.to_f
      end

      # If the new repayment amount pushes the repayment to become over repaid, tells them so
      if (amount_repaid_so_far + repayment_amount) > ActiveLoan.find(active_loan_id).opening_balance.to_f
        redirect_to show_active_loan_path(id: active_loan_id), notice: "You cannot repay more than what you owe. Please enter a lower repayment amount."
      
      elsif (amount_repaid_so_far + repayment_amount) <= ActiveLoan.find(active_loan_id).opening_balance.to_f

        # Calculates the percentage of loan being repaid:
        percent_being_repaid = repayment_amount / ActiveLoan.find(active_loan_id).opening_balance.to_f

        # Identifies all the investments that need to be repaid and creates repayment and transaction records
        Investment.where(active_loan_id: active_loan_id).each do |investment|

          individual_repayment_amount = (investment.opening_balance.to_f * percent_being_repaid).round(2)

          # Create repayment records for all investors who have loaned the borrower money
          Repayment.create!([
            {
              active_loan_id: active_loan_id,
              investment_id: investment.id,
              amount: individual_repayment_amount,
            }
          ])

          from_account_id = Account.where(user_id: investment.user_id).where(label: "Active investments").first.id
          to_account_id = Account.where(user_id: investment.user_id).where(label: "Cash").first.id
          
          # Create transaction records for all investors who have loaned the borrower money
          Transaction.create!([
            {
              amount: individual_repayment_amount,
              from_account_id: from_account_id,
              to_account_id: to_account_id,
              from_account_balance: (retrieve_balance(from_account_id).to_i - individual_repayment_amount),
              to_account_balance: (retrieve_balance(to_account_id).to_i + individual_repayment_amount),
              transaction_type: "principal"
            }
          ])
        end

        # Create transaction for lender to transfer money from outstanding loans to the cash account
        from_account_id = Account.where(user_id: current_user.id).where(label: "Cash").first.id
        to_account_id = Account.where(user_id: current_user.id).where(label: "Outstanding loans").first.id
        
        Transaction.create!([
          {
            amount: repayment_amount,
            from_account_id: from_account_id,
            to_account_id: to_account_id,
            from_account_balance: (retrieve_balance(from_account_id).to_i - repayment_amount),
            to_account_balance: (retrieve_balance(to_account_id).to_i + repayment_amount),
            transaction_type: "principal"
          }
        ])

        # Recalculate total repayments made to the loan so far
        amount_repaid_so_far = 0.0
        relevant_repayment_records = Repayment.where(active_loan_id: active_loan_id)
        relevant_repayment_records.each do |repayment_record|
          amount_repaid_so_far += repayment_record.amount.to_f
        end

        # If the new repayment amount pushes the loan to become 100% repaid, execute required Logic
        if amount_repaid_so_far == ActiveLoan.find(active_loan_id).opening_balance.to_f
          ActiveLoan.find(active_loan_id).update(status: "settled")
          redirect_to root_path, notice: "You have successfully repaid $#{repayment_amount / 100} to Loan ID: #{active_loan_id}. You do not owe any more money on that loan."
        # Else, just redirect to root_path
        else
          redirect_to root_path, notice: "You have successfully repaid $#{repayment_amount / 100} to Loan ID: #{active_loan_id}"
        end
      end
      
    else
      redirect_to root_path, notice: "You do not have enough in your Cash account to repay $#{repayment_amount / 100}."
    end

  end

end