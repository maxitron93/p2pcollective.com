class PagesController < ApplicationController
  
  def home
    @funded_active_loans = ActiveLoan.where(status: "unfunded").limit(9)
    @all_funded_active_loans_count = ActiveLoan.where(status: "unfunded").count
    all_funded_loans = ActiveLoan.where(status: "funded").or(ActiveLoan.where(status: "settled"))
    @total_amount = 0
    all_funded_loans.each do |loan|
      @total_amount =+ loan.opening_balance
    end
    render layout: "pages"
  end

end
