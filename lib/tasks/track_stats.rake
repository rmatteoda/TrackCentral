namespace :track_stats do
  desc "Task para generar promedios"

#genero recorrido promedio de cada vaca en las ultmas 72 horas
task generar_recorrido_promedio: :environment do    
    vacas = Vaca.all    
    
    vacas.each  do |vaca| 
      count = 0
      actividad_promedio = 0
      72.times do |n|
        hora = Time.now.advance(:hours => (-72+n).to_i)
        hora_start = hora.change(:min => 0) 
        hora_end = hora_start.advance(:hours => 1)
        
        actividad = vaca.actividades.where("tipo = 'recorrido' AND registrada >= ? and registrada < ?", hora_start,hora_end).first
        if !actividad.nil? && actividad.valor > 10  
          actividad_promedio = actividad_promedio + actividad.valor
          count = count + 1
        end 
      end

      if count > 0      
        actividad_promedio = (actividad_promedio/count)
        vaca.actividades.create!(registrada: Time.now.to_datetime, tipo: "recorrido_promedio", valor: actividad_promedio)
      end 
    end
end

end