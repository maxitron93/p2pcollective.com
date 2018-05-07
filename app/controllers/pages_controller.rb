class PagesController < ApplicationController
  def home
    @funded_active_loans = ActiveLoan.where(status: "unfunded")
    render layout: "pages"
  end

  def how_this_works

    render layout: "pages"
  end
  
  def borrow_money

    render layout: "pages"
  end

  def become_an_investor

    render layout: "pages"
  end

  def about_us

    render layout: "pages"
  end

  def contact_us

    render layout: "pages"
  end
end
