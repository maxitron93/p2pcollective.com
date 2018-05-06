require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "should get all" do
    get accounts_all_url
    assert_response :success
  end

end
