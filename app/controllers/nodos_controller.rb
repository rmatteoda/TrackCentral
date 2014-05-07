class NodosController < ApplicationController
  # GET /nodos
  # GET /nodos.json
  def index
    @nodos = Nodo.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @nodo = Nodo.find(params[:id])
  end

  def new
    @nodo = Nodo.new
  end

  def edit
    @nodo = Nodo.first
    @nodos = Nodo.all
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

  #usada para cambio de collar
  def update
    nueva_carv = params[:nodo][:vaca_id]
    nodo_id = params[:nodo][:nodo_id]
    
    nodo = Nodo.where("nodo_id = ?",nodo_id).first
    vaca_ant = Vaca.where("nodo_id = ?",nodo_id).first        
    
    vaca_check = Vaca.where("caravana = ?",nueva_carv)        
    if !vaca_check.blank?
      #flash[:error] = "ERROR: La Caravana " + nueva_carv.to_s + " ya asignada esta en el sistema"
      #redirect_to edit_nodo_path(:id => 1)
      vaca = vaca_check.first
    else
      vaca = Vaca.create!(caravana: nueva_carv,
                     raza: "Holando",
                     rodeo: 1,
                     estado: "Normal") 
    end

      vaca.nodo_id = nodo_id
      vaca.nodo = nodo
      vaca_ant.nodo_id = 0
      vaca_ant.nodo = nil
    
      if vaca.save  &&  vaca_ant.save
        flash[:success] = "Collar cambiado"
      end
      redirect_to vacas_path   
  end

  def destroy
    @nodo = Nodo.find(params[:id])
    @nodo.destroy
    flash[:success] = "Nodo Eliminado"
    redirect_to nodos_path
  end

end
