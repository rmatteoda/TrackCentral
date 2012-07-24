class NodosController < ApplicationController
  # GET /nodos
  # GET /nodos.json
  def index
    @nodos = Nodo.all
  end

  def show
    @nodo = Nodo.find(params[:id])
  end

  def new
    @nodo = Nodo.new
  end

  def edit
    @nodo = Nodo.find(params[:id])
  end

  def create
    @nodo = Nodo.new(params[:nodo])
    @nodo.bateria = 100

    if @nodo.save
       flash[:success] = "Nodo Creado"
       redirect_to nodos_path
      else
        render 'new'
    end
  end

  def update
    @nodo = Nodo.find(params[:id])

      if @nodo.update_attributes(params[:nodo])
        flash[:success] = "Informacion actualizada"
        redirect_to @user
      else
        render 'edit'
      end
  end

  def destroy
    @nodo = Nodo.find(params[:id])
    @nodo.destroy
    flash[:success] = "Nodo Eliminado"
    redirect_to nodos_path
  end

end
