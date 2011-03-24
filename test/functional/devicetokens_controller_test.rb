require 'test_helper'

class DevicetokensControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:devicetokens)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create devicetoken" do
    assert_difference('Devicetoken.count') do
      post :create, :devicetoken => { }
    end

    assert_redirected_to devicetoken_path(assigns(:devicetoken))
  end

  test "should show devicetoken" do
    get :show, :id => devicetokens(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => devicetokens(:one).to_param
    assert_response :success
  end

  test "should update devicetoken" do
    put :update, :id => devicetokens(:one).to_param, :devicetoken => { }
    assert_redirected_to devicetoken_path(assigns(:devicetoken))
  end

  test "should destroy devicetoken" do
    assert_difference('Devicetoken.count', -1) do
      delete :destroy, :id => devicetokens(:one).to_param
    end

    assert_redirected_to devicetokens_path
  end
end
