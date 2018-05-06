require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do

  describe "GET #awaiting_assessment" do
    it "returns http success" do
      get :awaiting_assessment
      expect(response).to have_http_status(:success)
    end
  end

end
