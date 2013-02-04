namespace :track_celo do
  desc "Task para detectar vacas en celo"
      
  #tarea que deberia correr a las 5 de la tarde y a las 5 de la mañana
  task detectar_celos: :environment do    
    #defino la actividad promedio de cada hora
    crear_actividad_promedio
    
    vacas = Vaca.all    
    vacas.each  do |vaca| 
      #controlo en celo de cada vaca que no fueron detectados en las ultimas 72 horas
      reciente = 72.hours.ago.to_datetime
      celo_reciente = Celo.where("vaca_id = ? AND comienzo >= ?", vaca.id,reciente)
      
      if !celo_reciente.any?
        controlar_celo(vaca)
      end 
    end
  end

  ####################### PRIVATE METHODS ################
private
  #controla si la vaca esta en celo
  def controlar_celo(vaca)
    actividad_vc_prom = vaca.actividades.where("tipo = 'recorrido_promedio' AND 
      registrada >= ?",26.hours.ago.to_datetime).first
    celo_detectado = 0  
    actividades_vc = []    
    actividades_prom = [] 

    24.times do |n|
      #hora = (24-n).hours.ago.to_datetime
      hora = Time.now.advance(:hours => (-24+n).to_i)
      hora_start = hora.change(:min => 0) 
      hora_end = hora_start.advance(:hours => 1)      
      
      actividades_vc[n] = 0
      actividades_prom[n] = 0
      
      actividad = vaca.actividades.where("tipo = 'recorrido_total' AND 
        registrada >= ? and registrada < ?", hora_start,hora_end).first
      actividad_promedio = Actividad.where("tipo = 'promedio' AND 
            registrada >= ? and registrada < ?", hora_start,hora_end).first
      
      #puts "hora de actividad " + hora_end.to_s
      if !actividad.nil?       
        actividades_vc[n] = actividad.valor
        if !actividad_promedio.nil?       
          actividades_prom[n] = actividad_promedio.valor
        end
      end
      
    end

    20.times do |n|
      periodo = n
      casos_prop = 0
      casos_prom = 0
      celo_start = nil

      if celo_detectado == 0
        8.times do |k|
          ind = periodo + k
          if ind < 24
            if actividades_prom[ind] > 0 && actividades_vc[ind] > (actividades_prom[ind] * 1.6)
              casos_prom = casos_prom + 1
            end

            if actividades_vc[ind] > 0 && actividades_vc[ind] > actividad_vc_prom.valor
              casos_prop = casos_prop + 1
            end
          end
        end
      end
      #si se detectaron varios casos, la vaca esta en celo
      if casos_prop >= 4 && casos_prom >= 4
           #celo_start = (24-periodo).hours.ago.to_datetime
            celo_start = Time.now.advance(:hours => (-24+periodo).to_i)
            #vaca.celos.create!(comienzo: celo_start,
            #                   probabilidad: "alta",
            #                   caravana: vaca.caravana,
            #                   causa: "aumento de actividad")
            celo_detectado = 1
            puts "celo detectado vaca "+ vaca.caravana.to_s + " start " + celo_start.to_s
      end 
    end
  end

  #PASAR A OTRO ARCHIVO (track_stats)
  # crea la actividad promedio de cada hora
  def crear_actividad_promedio
    24.times do |n|
      #hora = (24-n).hours.ago.to_datetime
      hora = Time.now.advance(:hours => (-24+n).to_i)
      hora_start = hora.change(:min => 0) 
      hora_end = hora_start.advance(:hours => 1)
      
      actividades = Actividad.where("tipo = 'recorrido_total' AND registrada >= ? 
        and registrada < ?", hora_start,hora_end)
      actividad_prom = Actividad.where("tipo = 'promedio' AND registrada >= ? 
        and registrada < ?", hora_start,hora_end)
      
      if !actividad_prom.any?
        actividad_promedio = 0
        count = 0
        actividades.each do |actividad| 
          if actividad.valor >= 0
            actividad_promedio = actividad_promedio + actividad.valor 
            count = count + 1
          end
        end

        if count > 0
          actividad_promedio = (actividad_promedio/count)
        end

        Actividad.create!(vaca_id: 0,registrada: hora_start, tipo: "promedio", valor: actividad_promedio)   
      end
    end
  end

  #temporal, para simular aumento de actividad de vaca en celo
  def actividad_celo(vaca)
    #puts "cargo vaca en celo " + vaca.caravana.to_s
    momento_celo_start = 8.hours.ago
    actividad_celo = vaca.actividades.where("registrada > ? ", momento_celo_start)
    
    actividad_celo.each do |actividad|
      actividad.valor = (actividad.valor) * 2.3
      actividad.save
    end
  end

end