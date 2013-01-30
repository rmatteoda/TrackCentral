namespace :track_stats do
  desc "Task para detectar vacas en celo"

task generar_recorrido_promedio: :environment do    
    vacas = Vaca.all    
    
    vacas.each  do |vaca| 
      count = 0
      actividad_promedio = 0
      72.times do |n|
        #hora = (72-n).hours.ago.to_datetime
        hora = Time.now.advance(:hours => (-72+n).to_i)
        hora_start = hora.change(:min => 0) 
        hora_end = hora_start.advance(:hours => 1)
        #controlo la actividad de cada hora en las ultimas 12
        actividad = vaca.actividades.where("tipo = 'recorrido_total' AND registrada >= ? and registrada < ?", hora_start,hora_end).first
        if !actividad.nil? && actividad.valor > 10  
          actividad_promedio = actividad_promedio + actividad.valor
          count = count + 1
        end 
      end

      if count > 0      
        actividad_promedio = (actividad_promedio/count)
        vaca.actividades.create!(registrada: Time.now.to_datetime, tipo: "recorrido_promedio", valor: actividad_promedio)
        #puts "promedio de vaca " + vaca.id.to_s + " - " + actividad_promedio.to_s
        #Actividad.create!(vaca_id: 0,registrada: hora_start, tipo: "promedio", valor: actividad_promedio)   
      end 
    end
  end
end