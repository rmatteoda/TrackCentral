class Alarma < ActiveRecord::Base
  attr_accessible :horas_de_valides, :mensaje, :nodo_id, :registrada, :tipo, :vaca_id, :vista
end
