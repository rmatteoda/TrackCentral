class CelosController < ApplicationController
include PlotHelper

	def index
		@vacas_en_celo = [Vaca.find(3),Vaca.find(4)]
		@celo_start = Date.today.to_datetime
	
		if params[:vaca_select].nil?
			@vaca_selected = @vacas_en_celo.first
		else
			@vaca_selected = Vaca.find(params[:vaca_select])
		end

		actividad_en_celo = @vaca_selected.actividades.where("valor > 100").first
		@celo_start = actividad_en_celo.registrada

		if @vaca_selected.actividades.any? 
          @act_chart = activitad_chart(@vaca_selected)
        end
	end

	def history
		@vaca_en_celo = Vaca.find(8)
		@celo_start = Date.today.advance(:days => -2).to_datetime
		@hist_chart = estadistica_celo_chart
	end

end
