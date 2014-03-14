namespace :track_stats do
  desc "Task para generar promedios"

#genero recorrido promedio de cada vaca en las ultmos 10 dias
task generar_recorrido_promedio: :environment do    
    vacas = Vaca.all    
    
    vacas.each  do |vaca| 
      count = 0
      actividad_promedio = 0
      
      delay = 10.days.ago
      actividades = vaca.actividades.where("tipo = 'recorrido' AND registrada >= ?", delay)
    
      actividades.each  do |actividad| 
        valor = actividad.valor
        if actividad.valor > 5
          actividad_promedio = actividad_promedio + valor
          count = count + 1       
        end
      end

      if count > 0      
        actividad_promedio = (actividad_promedio/count)
        #puts "actividad prom " + vaca.caravana.to_s + " es " + actividad_promedio.to_s      
        vaca.actividades.create!(registrada: Time.now.to_datetime, tipo: "recorrido_promedio", valor: actividad_promedio)
      end 
    end
end
end