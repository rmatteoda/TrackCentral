namespace :track_stats do
  desc "Task para generar promedios"

#genero recorrido promedio de cada vaca en las ultmas 72 horas

task generar_recorrido_promedio: :environment do    
    vacas = Vaca.all    
    
    vacas.each  do |vaca| 
      count = 0
      actividad_promedio = 0
      
      delay = 19.days.ago
      actividades = vaca.actividades.where("tipo = 'recorrido' AND registrada >= ?", delay)
    
      actividades.each  do |actividad| 
        valor = actividad.valor
        if actividad.valor > 8
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
#genero recorrido promedio de cada vaca en diferentes horarios
task generar_promedio_rango_hr: :environment do    
    f = File.open('./log/promedio_log.txt', 'a+')
    vacas = Vaca.all        
    vacas.each  do |vaca| 
    #vaca = Vaca.find(19)

    actividad_vc_prom = vaca.actividades.where("tipo = 'recorrido_promedio'").last
    f.puts "vaca " + vaca.caravana.to_s + " actividad promedio " + actividad_vc_prom.valor.to_s

    generar_promedio_hr(vaca,0,8,f)
    generar_promedio_hr(vaca,4,8,f)
    generar_promedio_hr(vaca,8,12,f)
    generar_promedio_hr(vaca,12,16,f)
    generar_promedio_hr(vaca,16,20,f)
    generar_promedio_hr(vaca,20,24,f)
    end
end

#genero recorrido promedio por rango horario
def generar_promedio_hr(vaca,hr_from,hr_to,f)     
  count = 0
  actividad_promedio = 0

  delay = 19.days.ago
  actividades = vaca.actividades.where("tipo = 'recorrido' AND registrada >= ?", delay)
    
  actividades.each  do |actividad| 
    reg_time = actividad.registrada.to_time.localtime
    reg_hour = reg_time.hour
    valor = actividad.valor
    if reg_hour >= hr_from && reg_hour < hr_to && actividad.valor > 8
      actividad_promedio = actividad_promedio + valor
      count = count + 1       
    end
  end
      
  #f = File.open('./log/promedio_log.txt', 'a+')
  if count > 0      
    actividad_promedio = (actividad_promedio/count)
  #    vaca.actividades.create!(registrada: Time.now.to_datetime, tipo: "recorrido_promedio_" + hr_from.to_s, 
  #      valor: actividad_promedio)
    f.puts "  - actividad rango desde " + hr_from.to_s + " hasta " + hr_to.to_s + " : " + actividad_promedio.to_s     
  end

end


task generar_recorrido_promedio_old: :environment do    
    vacas = Vaca.all    
    
    vacas.each  do |vaca| 
      count = 0
      actividad_promedio = 0
      70.times do |n|
        hora = Time.now.advance(:hours => (-70+n).to_i)
        hora_start = hora.change(:min => 0) 
        hora_end = hora_start.advance(:hours => 1)
        
        actividad = vaca.actividades.where("tipo = 'recorrido' AND registrada >= ? and registrada < ?", hora_start,hora_end).last
        if !actividad.nil? && actividad.valor > 8  
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