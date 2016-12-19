require 'test_helper'

class ResultSetsControllerTest < ActionController::TestCase
  setup do
    @result_set = result_sets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:result_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create result_set" do
    assert_difference('ResultSet.count') do
      post :create, result_set: {date: @result_set.date, name: @result_set.name, status: @result_set.status, version: @result_set.version}
    end

    assert_redirected_to result_set_path(assigns(:result_set))
  end

  test "should show result_set" do
    get :show, id: @result_set
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @result_set
    assert_response :success
  end

  test "should update result_set" do
    patch :update, id: @result_set, result_set: {date: @result_set.date, name: @result_set.name, status: @result_set.status, version: @result_set.version}
    assert_redirected_to result_set_path(assigns(:result_set))
  end

  test "should destroy result_set" do
    assert_difference('ResultSet.count', -1) do
      delete :destroy, id: @result_set
    end

    assert_redirected_to result_sets_path
  end
end
