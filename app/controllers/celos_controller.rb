class CelosController < ApplicationController
include PlotHelper

	def index
		@vacas_en_celo = Vaca.limit(3)
		@celo_start = Date.today.to_datetime
	
		if params[:vaca_select].nil?
			@vaca_selected = @vacas_en_celo.first
		else
			@vaca_selected = Vaca.find(params[:vaca_select])
		end

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
