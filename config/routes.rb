Rails.application.routes.draw do

  # Routes to browse and interact with active loans
  get '/active_loans/:status', to: 'active_loans#index', as: 'active_loans_index'
  get '/my_active_loans/:status', to: 'active_loans#my_index', as: 'my_active_loans_index'
  get '/my_investments/:status', to: 'active_loans#my_investments', as: 'my_investments'
  post '/approve_active_loan/:id', to: 'active_loans#approve', as: 'approve_active_loan'
  post '/invest/:id', to: 'active_loans#invest', as: 'investment'
  post '/repay_loan_confirmation', to: 'active_loans#repay_loan_confirmation', as: 'repay_loan_confirmation'
  get 'active_loan/:id', to: 'active_loans#show', as: 'show_active_loan'
  

  # Routes for employee accounts
  get '/awaiting_assessment', to: 'employees#awaiting_assessment', as: 'awaiting_assessment'
  get '/assess_application/:id', to: 'employees#assess_application', as: 'assess_application'
  post '/approve_application/:id', to: 'employees#approve_application', as: 'approve_application' 

  # Routes to navigate loan applications before they become live 
  get '/my_loan_applications/:status', to: 'loan_applications#index', as: 'my_loan_applications_with_status'
  resources :loan_applications
  
  #Routes for portfolios pages
  get '/add_cash', to: 'portfolios#add_cash', as: 'add_cash'
  get '/withdraw_cash', to: 'portfolios#withdraw_cash', as: 'withdraw_cash'
  post '/withdraw_confirmation', to: 'portfolios#withdraw_confirmation', as: 'withdraw_confirmation'
  
  get '/account_history/:id', to: 'portfolios#account_history', as: 'account_history'

  # Routes for buttons on nav page
  get '/my_loan_applications', to: 'portfolios#my_loan_applications', as: 'my_loan_applications'

  # Tables in Database
  get '/tables', to: 'tables#all_tables'
  get '/tables/table/:table_name', to: 'tables#table', as: 'table'

  devise_for :users

  # Sets root path based on if the visitor is logged in or not
  authenticated :user do
    root 'portfolios#all'
  end
  root 'pages#home'
  
  # Routes for guest users
  get '/how_this_works', to: 'pages#how_this_works', as: 'how_this_works'
  get '/borrow_money', to: 'pages#borrow_money', as: 'borrow_money'
  get '/become_an_investor', to: 'pages#become_an_investor', as: 'become_an_investor'
  get '/about_us', to: 'pages#about_us', as: 'about_us'
  get '/contact_us', to: 'pages#contact_us', as: 'contact_us'

  # Routes for stripe
  resources :charges
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
