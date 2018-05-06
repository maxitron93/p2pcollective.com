json.extract! loan_application, :id, :user_id, :loan_amount, :loan_term, :purpose, :created_at, :updated_at
json.url loan_application_url(loan_application, format: :json)
