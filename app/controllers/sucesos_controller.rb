class SucesosController < ApplicationController
  
  def new
    @suceso = Suceso.new
    @suceso.momento = Date.today
    @vacas = Vaca.all
  end


  def create
    @suceso = Suceso.new(params[:suceso])
    
    if @suceso.save
       flash[:success] = "Evento Agregado con exito"
       redirect_to root_path
    else
        render 'new'
    end
  end
end
