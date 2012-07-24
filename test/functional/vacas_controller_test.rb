require 'test_helper'

class VacasControllerTest < ActionController::TestCase
  setup do
    @vaca = vacas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vacas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vaca" do
    assert_difference('Vaca.count') do
      post :create, vaca: { caravana: @vaca.caravana, estado: @vaca.estado, nodo_id: @vaca.nodo_id, raza: @vaca.raza }
    end

    assert_redirected_to vaca_path(assigns(:vaca))
  end

  test "should show vaca" do
    get :show, id: @vaca
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vaca
    assert_response :success
  end

  test "should update vaca" do
    put :update, id: @vaca, vaca: { caravana: @vaca.caravana, estado: @vaca.estado, nodo_id: @vaca.nodo_id, raza: @vaca.raza }
    assert_redirected_to vaca_path(assigns(:vaca))
  end

  test "should destroy vaca" do
    assert_difference('Vaca.count', -1) do
      delete :destroy, id: @vaca
    end

    assert_redirected_to vacas_path
  end
end
