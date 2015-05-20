require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  setup do
    @new_record = new_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:new_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create new_record" do
    assert_difference('NewRecord.count') do
      post :create, new_record: { filename: @new_record.filename, location: @new_record.location }
    end

    assert_redirected_to new_record_path(assigns(:new_record))
  end

  test "should show new_record" do
    get :show, id: @new_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @new_record
    assert_response :success
  end

  test "should update new_record" do
    patch :update, id: @new_record, new_record: { filename: @new_record.filename, location: @new_record.location }
    assert_redirected_to new_record_path(assigns(:new_record))
  end

  test "should destroy new_record" do
    assert_difference('NewRecord.count', -1) do
      delete :destroy, id: @new_record
    end

    assert_redirected_to new_records_path
  end
end
