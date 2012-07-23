class NodosController < ApplicationController
  # GET /nodos
  # GET /nodos.json
  def index
    @nodos = Nodo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @nodos }
    end
  end

  # GET /nodos/1
  # GET /nodos/1.json
  def show
    @nodo = Nodo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @nodo }
    end
  end

  # GET /nodos/new
  # GET /nodos/new.json
  def new
    @nodo = Nodo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @nodo }
    end
  end

  # GET /nodos/1/edit
  def edit
    @nodo = Nodo.find(params[:id])
  end

  # POST /nodos
  # POST /nodos.json
  def create
    @nodo = Nodo.new(params[:nodo])
    @nodo.bateria = 100
    respond_to do |format|
      if @nodo.save
        format.html { redirect_to @nodo, notice: 'Nodo fue creado con exito.' }
        format.json { render json: @nodo, status: :created, location: @nodo }
      else
        format.html { render action: "new" }
        format.json { render json: @nodo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /nodos/1
  # PUT /nodos/1.json
  def update
    @nodo = Nodo.find(params[:id])

    respond_to do |format|
      if @nodo.update_attributes(params[:nodo])
        format.html { redirect_to @nodo, notice: 'Nodo actualizado!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @nodo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nodos/1
  # DELETE /nodos/1.json
  def destroy
    @nodo = Nodo.find(params[:id])
    @nodo.destroy

    respond_to do |format|
      format.html { redirect_to nodos_url }
      format.json { head :no_content }
    end
  end
end
