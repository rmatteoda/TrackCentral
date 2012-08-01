class AlarmasController < ApplicationController
  
  def index
  	@alarmas_servicio = Alarma.where("tipo = ? ",'servicios')
  	
  	@alarmas_parto = Alarma.where("tipo = 'post-parto'")
  	
	@alarmas_celo = Alarma.where("tipo = 'celo_detectado'")
  end
end
