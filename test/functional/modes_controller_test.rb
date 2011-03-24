require 'test_helper'

class ModesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:modes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mode" do
    assert_difference('Mode.count') do
      post :create, :mode => { }
    end

    assert_redirected_to mode_path(assigns(:mode))
  end

  test "should show mode" do
    get :show, :id => modes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => modes(:one).to_param
    assert_response :success
  end

  test "should update mode" do
    put :update, :id => modes(:one).to_param, :mode => { }
    assert_redirected_to mode_path(assigns(:mode))
  end

  test "should destroy mode" do
    assert_difference('Mode.count', -1) do
      delete :destroy, :id => modes(:one).to_param
    end

    assert_redirected_to modes_path
  end
end
