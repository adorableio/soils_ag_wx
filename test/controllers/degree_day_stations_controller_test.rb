require 'test_helper'

class DegreeDayStationsControllerTest < ActionController::TestCase
  setup do
    @degree_day_station = degree_day_stations(:one)
    @region = regions(:central)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:degree_day_stations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create degree_day_station" do
    assert_difference('DegreeDayStation.count') do
      post :create, params: { degree_day_station: { abbrev: @degree_day_station.abbrev, latitude: @degree_day_station.latitude, longitude: @degree_day_station.longitude, name: @degree_day_station.name, region_id: @region.id} }
    end

    assert_redirected_to degree_day_station_path(assigns(:degree_day_station))
  end

  test "should show degree_day_station" do
    get :show, params: { id: @degree_day_station }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @degree_day_station }
    assert_response :success
  end

  test "should update degree_day_station" do
    patch :update, params: { id: @degree_day_station, degree_day_station: { abbrev: @degree_day_station.abbrev, latitude: @degree_day_station.latitude, longitude: @degree_day_station.longitude, name: @degree_day_station.name, region_id: @region.id } }
    assert_redirected_to degree_day_station_path(assigns(:degree_day_station))
  end

  test "should destroy degree_day_station" do
    assert_difference('DegreeDayStation.count', -1) do
      delete :destroy, params: { id: @degree_day_station }
    end

    assert_redirected_to degree_day_stations_path
  end
end
