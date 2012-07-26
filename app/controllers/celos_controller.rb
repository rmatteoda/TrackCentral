class CelosController < ApplicationController

	def index
		@vacas_en_celo = Vaca.limit(3)
		@celo_start = Date.today.to_datetime
	end
end
