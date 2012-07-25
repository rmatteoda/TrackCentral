class VacasController < ApplicationController
  
  def index
    @vacas = Vaca.all
  end

  def show
    @vaca = Vaca.find(params[:id])
  end

  def new
    @vaca = Vaca.new
    @nodos = nodos_disponibles
  end

  def edit
    @vaca = Vaca.find(params[:id])
    @nodos = nodos_disponibles
    if !@vaca.nodo.nil?
      @nodos.push(@vaca.nodo)
    end
  end

  def create
    @vaca = Vaca.new(params[:vaca])
    
    if @vaca.save
      if !@vaca.nodo_id.nil? && !@vaca.nodo_id.blank? 
        @vaca.nodo = Nodo.where("nodo_id = ?",@vaca.nodo_id).first
      end
      flash[:success] = "Vaca creada con exito"
      redirect_to @vaca
    else
      @nodos = nodos_disponibles
      render 'new'
    end
  end

  def update
    @vaca = Vaca.find(params[:id])
    
      if @vaca.update_attributes(params[:vaca])
        if !@vaca.nodo_id.nil? && !@vaca.nodo_id.blank? 
          @vaca.nodo = Nodo.where("nodo_id = ?",@vaca.nodo_id).first
        end
        if !@vaca.nodo_id.nil? && @vaca.nodo_id.blank? 
          @vaca.nodo = nil
        end
        flash[:success] = "Vaca actualizada"
        redirect_to @vaca
      else
        @nodos = nodos_disponibles
        if !@vaca.nodo_id.nil?
          @nodos.push(@vaca.nodo)
        end
        render 'edit'
      end
   end

  def destroy
    @vaca = Vaca.find(params[:id])
    @vaca.nodo = nil
    @vaca.destroy
    flash[:success] = "Vaca eliminada"
    redirect_to vacas_path
  end

  private 

  def nodos_disponibles
    @nodos = Nodo.where("vaca_id IS NULL")
  end

end