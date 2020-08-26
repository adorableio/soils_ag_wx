require 'test_helper'

class AsosDataControllerTest < ActionController::TestCase
  setup do
    @asos_datum = asos_data(:one)
    @asos_station = asos_stations(:one)
  end

  test "should get index" do
    get :index, params: { asos_station_id: @asos_datum.asos_station_id }
    assert_response :success
    assert_not_nil assigns(:asos_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create asos_datum" do
    assert_difference('AsosDatum.count') do
      post :create, params: { asos_station: { stnid: @asos_datum.asos_station_id }, asos_datum: { actual_time: @asos_datum.actual_time, asos_station_id: @asos_station.id, date: @asos_datum.date, nominal_time: @asos_datum.nominal_time, precip: @asos_datum.precip, pressure: @asos_datum.pressure, t_air: @asos_datum.t_air, t_dew: @asos_datum.t_dew, wind_dir: @asos_datum.wind_dir, windspeed: @asos_datum.windspeed } }
    end

    assert_redirected_to asos_datum_path(assigns(:asos_datum))
  end

  test "should show asos_datum" do
    get :show, params: { id: @asos_datum }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @asos_datum }
    assert_response :success
  end

  test "should update asos_datum" do
    patch :update, params: { id: @asos_datum, asos_station: { stnid: @asos_datum.asos_station_id }, asos_datum: { actual_time: @asos_datum.actual_time, asos_station_id: @asos_station.id, date: @asos_datum.date, nominal_time: @asos_datum.nominal_time, precip: @asos_datum.precip, pressure: @asos_datum.pressure, t_air: @asos_datum.t_air, t_dew: @asos_datum.t_dew, wind_dir: @asos_datum.wind_dir, windspeed: @asos_datum.windspeed } }
    assert_redirected_to asos_datum_path(assigns(:asos_datum))
  end

  test "should destroy asos_datum" do
    assert_difference('AsosDatum.count', -1) do
      delete :destroy, params: { id: @asos_datum }
    end

    assert_redirected_to asos_data_path
  end
end
