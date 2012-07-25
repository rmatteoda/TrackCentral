require 'test_helper'

class AlarmasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
