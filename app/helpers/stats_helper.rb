module StatsHelper

############################################################################
###  retorna la actividad promedio en una hora registrada
############################################################################
def actividad_promedio_en(momento)
 from = momento.advance(:minutes => -10) 
 to   = momento.advance(:minutes => 10) 
 
 actividades = Actividad.where("registrada between ? and ? and tipo = ?", from,to,'promedio')
 actividad_promedio = calcular_promedio_en(momento)
 
 return actividad_promedio
end

def calcular_promedio_en(momento)
 from = momento.advance(:minutes => -10) 
 to   = momento.advance(:minutes => 10) 
 actividades = Actividad.where("registrada between ? and ? and tipo = ?", from,to,'recorrido')

 actividad_promedio = 0
 count = 0

 actividades.each do |actividad| 
  if actividad.valor > 1
    count = count + 1
    actividad_promedio = actividad_promedio + actividad.valor
  end
 end

 if count > 0
    actividad_promedio = (actividad_promedio/count)
 end
 
 return actividad_promedio
end

end
