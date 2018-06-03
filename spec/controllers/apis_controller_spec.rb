require 'rails_helper'

RSpec.describe ApisController, type: :controller do

  describe "GET #plan_get_data" do
    it "returns http success" do
      get :plan_get_data
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #plan_post_data" do
    it "returns http success" do
      get :plan_post_data
      expect(response).to have_http_status(:success)
    end
  end

end
