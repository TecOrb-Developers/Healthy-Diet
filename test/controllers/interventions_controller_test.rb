require 'test_helper'

class InterventionsControllerTest < ActionController::TestCase
  setup do
    @intervention = interventions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:interventions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create intervention" do
    assert_difference('Intervention.count') do
      post :create, intervention: { description: @intervention.description, intervention_type_id: @intervention.intervention_type_id, name: @intervention.name }
    end

    assert_redirected_to intervention_path(assigns(:intervention))
  end

  test "should show intervention" do
    get :show, id: @intervention
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @intervention
    assert_response :success
  end

  test "should update intervention" do
    patch :update, id: @intervention, intervention: { description: @intervention.description, intervention_type_id: @intervention.intervention_type_id, name: @intervention.name }
    assert_redirected_to intervention_path(assigns(:intervention))
  end

  test "should destroy intervention" do
    assert_difference('Intervention.count', -1) do
      delete :destroy, id: @intervention
    end

    assert_redirected_to interventions_path
  end
end
