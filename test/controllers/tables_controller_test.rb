require 'test_helper'

class TablesControllerTest < ActionDispatch::IntegrationTest
  test "should get all_tables" do
    get tables_all_tables_url
    assert_response :success
  end

  test "should get table" do
    get tables_table_url
    assert_response :success
  end

end
