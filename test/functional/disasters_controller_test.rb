require 'test_helper'

class DisastersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:disasters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create disaster" do
    assert_difference('Disaster.count') do
      post :create, :disaster => { }
    end

    assert_redirected_to disaster_path(assigns(:disaster))
  end

  test "should show disaster" do
    get :show, :id => disasters(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => disasters(:one).to_param
    assert_response :success
  end

  test "should update disaster" do
    put :update, :id => disasters(:one).to_param, :disaster => { }
    assert_redirected_to disaster_path(assigns(:disaster))
  end

  test "should destroy disaster" do
    assert_difference('Disaster.count', -1) do
      delete :destroy, :id => disasters(:one).to_param
    end

    assert_redirected_to disasters_path
  end
end
