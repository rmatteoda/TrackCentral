class CelosController < ApplicationController
include PlotHelper

	def index
		#@vacas_en_celo = [Vaca.find(3),Vaca.find(4)]
		#@celo_start = Date.today.to_datetime
		#actividad_en_celo = @vaca_selected.actividades.where("valor > 100").first
		#@celo_start = actividad_en_celo.registrada

		@celos = Celo.where("comienzo >= ?", 18.hours.ago)
		if @celos.any?
			if params[:vaca_select].nil?
				@vaca_selected = Vaca.find(@celos.first.vaca_id)
			else
				@vaca_selected = Vaca.find(params[:vaca_select])
			end

			if @vaca_selected.actividades.any? 
	          @act_chart = activitad_chart(@vaca_selected)
	        end
    	end
	end

	def history
		@celos = Celo.where("comienzo >= ?", 7.days.ago)
		@hist_chart = estadistica_celo_chart
	end

end
