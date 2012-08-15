namespace :track_celo do
  desc "Task para detectar vacas en celo"
  #Rake::Task['morning:make_coffee'].invoke
      
  task detectar_celos: :environment do
    #defino la actividad promedio de cada hora
    crear_actividad_promedio

    vacas = Vaca.all    
    vacas.each  do |vaca| 
      #controlo en celo de cada vaca que no fueron detectados en las ultimas 36 horas
      #en un futuro se podria aumentar a dias, ya que entran cada 21 dias aproximadamente
      reciente = 36.hours.ago.to_datetime
      celo_reciente = Celo.where("vaca_id = ? AND comienzo >= ?", vaca.id,reciente)

      if !celo_reciente.any?
        controlar_celo(vaca)
      end 
    end

  end

  #task temporal, es para marcar algunas vacas en celo y que sean detectadas por aumento de actividad
  task simular_celos: :environment do
    celo_id = (rand * (1 - 50) + 50).to_i
    vaca = Vaca.find(celo_id)
    actividad_celo(vaca)
    puts "simulado para " + vaca.caravana.to_s

    celo_id = (rand * (1 - 50) + 50).to_i
    vaca = Vaca.find(celo_id)
    actividad_celo(vaca)
    puts "simulado para " + vaca.caravana.to_s
  end

  ####################### PRIVATE METHODS ################
private
  #controla si la vaca esta en celo
  def controlar_celo(vaca)
    casos = 0
    celo_start = nil

  	24.times do |n|
      hora = (24-n).hours.ago.to_datetime
      hora_start = hora.change(:min => 0) 
      hora_end = hora_start.advance(:hours => 1)
      #controlo la actividad de cada hora en las ultimas 12
      actividad = vaca.actividades.where("tipo = 'recorrido' AND registrada >= ? and registrada < ?", hora_start,hora_end).first
      if !actividad.nil?       
          #controlo actividad previa para detectar el comienzo
          actividad_prev = vaca.actividades.where("tipo = 'recorrido' AND registrada >= ? and registrada < ?", 
            hora_start.advance(:hours => -2),hora_end.advance(:hours => -2)).first
          #controlo actividad pasada del dia anterior a la misma hora
          actividad_old = vaca.actividades.where("tipo = 'recorrido' AND registrada >= ? and registrada < ?", 
            hora_start.advance(:hours => -24),hora_end.advance(:hours => -24)).first
          
          #controlo aumento respecto de la actividad promedio
          actividad_promedio = Actividad.where("tipo = 'promedio' AND registrada >= ? and registrada < ?", hora_start,hora_end).first
          if !actividad_promedio.nil? && actividad.valor > (actividad_promedio.valor * 1.8)
           # puts "mayor actividad que la promedio " + vaca.caravana.to_s + " : " + actividad.valor.to_s
            casos = casos + 1
          end

          if !actividad_old.valor.nil? && (actividad.valor > (actividad_old.valor * 2.0))
            #puts "mayor actividad que ayer " + vaca.caravana.to_s
            casos = casos + 1
          end
          
          if actividad.valor > (actividad_prev.valor * 1.5) && celo_start.nil?
            celo_start = hora_start
            casos = casos + 1
          end
      end

    end

    #si se detectaron varios casos, la vaca esta en celo
    if casos > 5
        #puts "vaca " + vaca.caravana.to_s + " en celo desde " + celo_start.to_s 
        vaca.celos.create!(comienzo: celo_start,
                           probabilidad: "alta",
                           causa: "aumento de actividad")
    end

  end

  #PASAR A OTRO ARCHIVO
  # crea la actividad promedio de cada hora
  def crear_actividad_promedio
    24.times do |n|
      hora = (24-n).hours.ago.to_datetime
      hora_start = hora.change(:min => 0) 
      hora_end = hora_start.advance(:hours => 1)
      
      actividades = Actividad.where("tipo = 'recorrido' AND registrada >= ? and registrada < ?", hora_start,hora_end)
      actividad_prom = Actividad.where("tipo = 'promedio' AND registrada >= ? and registrada < ?", hora_start,hora_end)
      
      if !actividad_prom.any?
        actividad_promedio = 0
        actividades.each { |actividad| actividad_promedio = actividad_promedio + actividad.valor}
        if actividades.count > 0
          actividad_promedio = (actividad_promedio/actividades.count)
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