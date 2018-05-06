def calculate_monthly_repayment(loan_amount, loan_term_in_months, annual_basis_points)
  r = ((annual_basis_points.to_f / 10000) / 12)
  pv = (loan_amount.to_f / 100)
  n = loan_term_in_months

  payment = (r * pv) / (1 - ((1 + r) ** (n * -1)))
  
  return payment
end