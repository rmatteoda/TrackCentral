require 'test_helper'

class NodosControllerTest < ActionController::TestCase
  setup do
    @nodo = nodos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nodos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nodo" do
    assert_difference('Nodo.count') do
      post :create, nodo: { bateria: @nodo.bateria, nodo_id: @nodo.nodo_id, vaca_id: @nodo.vaca_id }
    end

    assert_redirected_to nodo_path(assigns(:nodo))
  end

  test "should show nodo" do
    get :show, id: @nodo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nodo
    assert_response :success
  end

  test "should update nodo" do
    put :update, id: @nodo, nodo: { bateria: @nodo.bateria, nodo_id: @nodo.nodo_id, vaca_id: @nodo.vaca_id }
    assert_redirected_to nodo_path(assigns(:nodo))
  end

  test "should destroy nodo" do
    assert_difference('Nodo.count', -1) do
      delete :destroy, id: @nodo
    end

    assert_redirected_to nodos_path
  end
end
