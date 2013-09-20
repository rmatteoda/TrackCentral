module StatsHelper

############################################################################
###  retorna la actividad promedio en una hora registrada
############################################################################
def actividad_promedio_en(momento)
 from = momento.advance(:minutes => -10) 
 to   = momento.advance(:minutes => 10) 
 
 actividades = Actividad.where("registrada between ? and ? and tipo = ?", from,to,'promedio')
 
 if actividades.any? 
 	actividad_promedio = actividades.first.valor
 else	
    actividad_promedio = calcular_promedio_en(momento)
 end

 return actividad_promedio
end

def calcular_promedio_en(momento)
 from = momento.advance(:minutes => -10) 
 to   = momento.advance(:minutes => 10) 
 actividades = Actividad.where("registrada between ? and ? and tipo = ?", from,to,'recorrido')
 actividad_promedio = 0
 actividades.each { |actividad| actividad_promedio = actividad_promedio + actividad.valor}
 
 if actividades.count > 0
  actividad_promedio = (actividad_promedio/actividades.count)
 end
 
 return actividad_promedio
end

end
