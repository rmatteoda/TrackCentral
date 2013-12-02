class CelosController < ApplicationController
include PlotHelper
include VacasHelper

	def index
		#@celos = Celo.where("comienzo >= ?", 24.hours.ago)
		@vacas_en_celo = Vaca.joins(:celos).where("comienzo >= ?", 24.hours.ago)
		
		if @vacas_en_celo.any?
			if params[:vaca_select].nil?
				@vaca_selected = @vacas_en_celo.first
			else
				@vaca_selected = Vaca.find(params[:vaca_select])
			end

			if @vaca_selected.actividades.any? 
	          @act_chart = activitad_total_chart(@vaca_selected)
	        end
    	end
	end

	#historial de vacas en celo, ultimos 7 dias y grafico estadistico mensual
	def history
		@vacas_en_celo = Vaca.joins(:celos).where("comienzo >= ?", 10.days.ago)
		@hist_chart = estadistica_celo_chart_high
	end

	#listado de vacas para observar por ultimo celo 19 a 25 dias
	def observer_list
		@vacas_sel = Vaca.joins(:celos).where("comienzo >= ? AND comienzo < ?", 25.days.ago, 18.days.ago)
	    #mejorar query para no hacer esto
		@vacas_en_obsrv = []
	    @ult_serv_vacas_en_obsrv = []
	    @vacas_sel.each do |vaca|
	    	if vaca.celos.first.comienzo < 18.days.ago
	    	  @vacas_en_obsrv.push(vaca)
	    	  @ult_serv_vacas_en_obsrv.push(ultimo_servicio(vaca))
	    	end
	    end
	end
end
