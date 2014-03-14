class AlarmasController < ApplicationController
  
  def index
  	@alarmas_servicio = Alarma.where("tipo = ? ",'servicios')
  	
  	@alarmas_parto = Alarma.where("tipo = 'post-parto'")
  	
	@alarmas_bat_collar = Alarma.where("tipo = 'bateria_collar'")

	@alarmas_collar = Alarma.where("tipo = 'collar_sin_datos'")

	@alarmas = Alarma.paginate(:page => params[:page], :per_page => 10)	
  end
end
