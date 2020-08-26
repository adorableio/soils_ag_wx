require 'test_helper'

class AwonControllerTest < ActionController::TestCase
  test "should get awon_check_boxes" do
    get :awon_check_boxes
    assert_response :success
  end

  test "should get station_info" do
    get :station_info
    assert_response :success
  end

  test "should get graphs" do
    get :graphs
    assert_response :success
  end

  test "should get graphs_soiltemp" do
    get :graphs_soiltemp
    assert_response :success
  end

  test "should get blog" do
    blogs(:one)
    get :blog
    assert_response :success
  end

  test "should get awon_seven_day" do
    awon_stations(:one).update!(stnid: 4751)
    awon_stations(:two).update!(stnid: 4781)
    get :awon_seven_day
    assert_response :success
  end

  test "should get download_data" do
    get :download_data
    assert_response :success
  end

end
