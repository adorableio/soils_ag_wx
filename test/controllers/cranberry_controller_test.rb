require 'test_helper'

class CranberryControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get summary" do
    skip :success
  end

end
