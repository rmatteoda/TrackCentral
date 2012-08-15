module VacasHelper

	def ultimo_parto(vaca)
		sucesos_parto = vaca.sucesos.where("tipo = 'parto'").order("momento DESC")
   		@ultimo_parto = ""
 	  	@ultimo_parto = sucesos_parto.first.momento if sucesos_parto.any?
	end

	def ultimo_celo(vaca)
		#celos = vaca.celos.order("comienzo DESC")
   		celos = vaca.celos
   		@ultimo_celo = ""
 	  	@ultimo_celo = celos.first.comienzo if celos.any?
	end

	def ultimo_servicio(vaca)
		sucesos_serv = vaca.sucesos.where("tipo = 'servicio'").order("momento DESC")
   		@ultimo_servicio = ""
 	  	@ultimo_servicio = sucesos_serv.first.momento if sucesos_serv.any?
	end

	def servicios_post_parto(vaca)
   		sucesos_parto = vaca.sucesos.where("tipo = 'parto'").order("momento DESC")
   		@ultimo_parto = 1.year.ago.to_date
 	  	@ultimo_parto = sucesos_parto.first.momento if sucesos_parto.any?
		
		sucesos_serv_pp = vaca.sucesos(true).where("momento > ? and tipo = 'servicio'",@ultimo_parto)
    	@servicios_post_parto = 0
 		@servicios_post_parto = sucesos_serv_pp.count if sucesos_serv_pp.any?
 	end

end
