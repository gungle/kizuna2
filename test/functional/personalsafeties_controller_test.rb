require 'test_helper'

class PersonalsafetiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:personalsafeties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create personalsafety" do
    assert_difference('Personalsafety.count') do
      post :create, :personalsafety => { }
    end

    assert_redirected_to personalsafety_path(assigns(:personalsafety))
  end

  test "should show personalsafety" do
    get :show, :id => personalsafeties(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => personalsafeties(:one).to_param
    assert_response :success
  end

  test "should update personalsafety" do
    put :update, :id => personalsafeties(:one).to_param, :personalsafety => { }
    assert_redirected_to personalsafety_path(assigns(:personalsafety))
  end

  test "should destroy personalsafety" do
    assert_difference('Personalsafety.count', -1) do
      delete :destroy, :id => personalsafeties(:one).to_param
    end

    assert_redirected_to personalsafeties_path
  end
end
