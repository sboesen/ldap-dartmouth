require 'test_helper'

class LdapGroupControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

end
