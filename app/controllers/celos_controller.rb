class CelosController < ApplicationController
include PlotHelper

	def index
		@celos = Celo.where("comienzo >= ?", 18.hours.ago)
		if @celos.any?
			if params[:vaca_select].nil?
				@vaca_selected = Vaca.find(@celos.first.vaca_id)
			else
				@vaca_selected = Vaca.find(params[:vaca_select])
			end

			if @vaca_selected.actividades.any? 
	          @act_chart = activitad_total_chart(@vaca_selected)
	        end
    	end
	end

	def history
		@celos = Celo.where("comienzo >= ?", 7.days.ago)
		@hist_chart = estadistica_celo_chart_high
	end

end
