class LoanApplicationsController < ApplicationController
  require 'check_login'
  require 'check_user'
  require 'check_loan_status'
  before_action :require_login
  before_action :compare_user_id, only: [:edit, :update, :destroy, :submit, :show]
  before_action :set_loan_application, only: [:show, :edit, :update, :destroy]
  before_action :check_status, only: [:edit, :update, :destroy, :submit]
  
  
  # GET /loan_applications
  # GET /loan_applications.json
  def index
    @loan_applications = LoanApplication.where(user_id: current_user.id).where(status: params[:status])
    @status = params[:status]

    render layout: "portfolios"
  end

  # GET /loan_applications/1
  # GET /loan_applications/1.json
  def show
    @status = params[:status]

    render layout: "portfolios"
  end

  # GET /loan_applications/new
  def new
    @loan_application = LoanApplication.new

    render layout: "portfolios"
  end

  # GET /loan_applications/1/edit
  def edit
    render layout: "portfolios"
  end

  # POST /loan_applications
  # POST /loan_applications.json
  def create
    
    @loan_application = LoanApplication.new(loan_application_params)
    @loan_application.user_id = current_user.id
    custom_params = loan_application_params

    if params[:submit]
      @loan_application.status = "being assessed"
    else
      @loan_application.status = "saved"
    end

    @loan_application.loan_amount = (params[:loan_application].require(:loan_amount).to_i * 100)
    @loan_application.weekly_income = (params[:loan_application].require(:weekly_income).to_i * 100)
    @loan_application.weekly_expenses = (params[:loan_application].require(:weekly_expenses).to_i * 100)
    

    respond_to do |format|
      if @loan_application.save
        if params[:submit]
          format.html { redirect_to my_loan_applications_path, notice: 'Loan application was successfully submitted.' }
        else
          format.html { redirect_to my_loan_applications_path, notice: 'Loan application was successfully saved.' }
        end
        format.json { render :show, status: :created, location: @loan_application }
      else
        format.html { render :new }
        format.json { render json: @loan_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loan_applications/1
  # PATCH/PUT /loan_applications/1.json
  def update
    respond_to do |format|
      
      if params[:submit]
        @loan_application.status = "being assessed"
      else
        @loan_application.status = "saved"
      end

      if @loan_application.update(loan_application_params)
        @loan_application.update(loan_amount: params[:loan_application].require(:loan_amount).to_i * 100, weekly_income: params[:loan_application].require(:weekly_income).to_i * 100, weekly_expenses: params[:loan_application].require(:weekly_expenses).to_i * 100)
        if params[:submit]
          format.html { redirect_to my_loan_applications_path, notice: 'Loan application was successfully submitted.' }
        else
          format.html { redirect_to my_loan_applications_path, notice: 'Loan application was successfully updated.' }
        end
        format.json { render :show, status: :ok, location: @loan_application }
      else
        format.html { render :edit }
        format.json { render json: @loan_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loan_applications/1
  # DELETE /loan_applications/1.json
  def destroy
    @loan_application.destroy
    respond_to do |format|
      format.html { redirect_to my_loan_applications_path, notice: 'Loan application was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def submit

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan_application
      @loan_application = LoanApplication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def loan_application_params
      params.require(:loan_application).permit(:first_name, :last_name, :loan_term, :purpose, :loan_category_id, :street_address, :city, :state, :postcode, :employment_type_id, :work_gap_months, :license, :pay_slip)
    end
end