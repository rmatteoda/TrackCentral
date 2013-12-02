namespace :track_celo do
  desc "Task para detectar vacas en celo"
  
  #tarea que deberia correr a medida que descargan datos los collares
  task detectar_celos: :environment do    
    #defino la actividad promedio de cada hora
      hora = Time.now.advance(:hours => (-4).to_i).localtime
      hora_start = hora.change(:min => 0) 
      hora_end = hora_start.advance(:minutes => 10)
      
      actividades = Actividad.where("tipo = 'recorrido' AND registrada >= ? and registrada < ?", hora_start,hora_end)
      
      #if actividades.size > 6 #al menos 8 vacas registradas para detectar. evaluar este numero??
        crear_actividad_promedio
      
        vacas = Vaca.all    
        vacas.each  do |vaca| 
         #vaca = Vaca.find(18)

          #elimino celos probables detectados en el ordeñe anterior
          reciente = 24.hours.ago.to_datetime
          celo_probables = Celo.where("vaca_id = ? AND comienzo >= ? AND probabilidad= 'Media'", vaca.id,reciente)
          if celo_probables.any?
            celo_probables.destroy_all
          end

          #controlo en celo de cada vaca que no fueron detectados en las ultimas 48 horas
          #aumentar a 15 dias cuando este el sistema equilibrado
          reciente = 48.hours.ago.to_datetime
          celo_reciente = Celo.where("vaca_id = ? AND comienzo >= ? AND probabilidad= 'Alta'", vaca.id,reciente)

        if !celo_reciente.any?
          #puts "busco celo " + vaca.caravana.to_s
          controlar_celo(vaca)
        end 
       end
    #end
  end

  #task temporal, es para marcar algunas vacas en celo 
  #que sean detectadas por aumento de actividad: simulacion
  task simular_celos: :environment do
    celo_id = (rand * (1 - 15) + 15).to_i
    vaca = Vaca.find(celo_id)
    puts "creo celo vaca " + vaca.id.to_s
    actividad_celo(vaca)
    
    celo_id = (rand * (1 - 15) + 15).to_i
    vaca = Vaca.find(celo_id)
    actividad_celo(vaca)
  end

  #guardar en archivo los celos detectados en los ultimos dias, para control
  task dump_celos: :environment do
    celos = Celo.where("comienzo >= ?", 25.days.ago)
    File.open('./log/register_celos_log.txt', 'a+') do |f|     
      celos.each  do |celo| 
        f.puts "celo " + celo.caravana.to_s + " " + celo.comienzo.to_s
      end
    end
  end

####################### PRIVATE METHODS ################
private
  ########################################################################## 
  ### controla si la vaca esta en celo
  ########################################################################## 
  def controlar_celo(vaca)
    #obtengo actividad promedio de la vaca
    actividad_vc_prom = vaca.actividades.where("tipo = 'recorrido_promedio' AND registrada >= ?", 50.hours.ago.to_datetime).last
    #puts "vaca " + vaca.caravana.to_s + " actividad promedio " + actividad_vc_prom.valor.to_s

    #genero array de actividad de vaca y actividad promedio para comparar y detectar celo
    actividades_vc,actividades_prom = generate_actividad_vaca(vaca) 
    
    celo_detectado = 0  

    20.times do |n|
      #inicializo las variables en cada iteracion
      periodo = n
      casos_prop = 0
      casos_prom = 0
      celo_start = nil
      hora_start = 0

      #si ya se detecto celo , no controlo
      if celo_detectado == 0
        7.times do |k|
          ind = periodo + k
          if ind < 24
            if (actividades_prom[ind] > 0) && actividades_vc[ind] > (actividades_prom[ind] * 1.7) 
                #aumento casos para posible celo
                casos_prom = casos_prom + 1
                if hora_start == 0
                  hora_start = ind 
                end
            end

            if actividades_vc[ind] > 0 && !actividad_vc_prom.nil? && actividades_vc[ind] > (actividad_vc_prom.valor*1.65)
              if (actividades_prom[ind] > 0) && actividades_vc[ind] > (actividades_prom[ind] * 1.5)
                 casos_prop = casos_prop + 1
              end
            end
          end
        end
      end
      
      #regular umbral . 4? si se detectaron varios casos, la vaca esta en celo
      if casos_prop >= 4 && casos_prom >= 3
          celo_start = Time.now.advance(:hours => (-23+hora_start).to_i).localtime
          celo_start = celo_start.change(:min => 0)
          vaca.celos.create!(comienzo: celo_start,
                              probabilidad: "Alta",
                              caravana: vaca.caravana,
                              causa: "notable aumento de actividad en varias horas")
          celo_detectado = 1
          puts "vaca en celo " + vaca.caravana.to_s + " comienzo " + celo_start.localtime.to_s
          
          #si esta en celo creo el suceso
          vaca.sucesos.create!(momento: celo_start, tipo: "celo")
      end 

      #vaca con aumento de actividad reciente, puede estar por entrar en celo
      if casos_prop >= 3 && casos_prom >= 2 
          celo_start = Time.now.advance(:hours => (-23+hora_start).to_i).localtime
          dif = ((Time.now.localtime - celo_start) / 3600).round
          if dif < 5
            celo_start = celo_start.change(:min => 0)
            # vaca.celos.create!(comienzo: celo_start,probabilidad: "Media",caravana: vaca.caravana,
            #                  causa: "aumento de actividad reciente, puede estar en celo")
          end
      end
    end              
  end

  def generate_actividad_vaca(vaca)
    actividades_vc = []    
    actividades_prom = [] 

    24.times do |n|
      hora = Time.now.advance(:hours => (-24+n).to_i).localtime
      hora_start = hora.change(:min => 0) 
      hora_end = hora_start.advance(:minutes => 10)      
      
      actividades_vc[n] = 0 #almaceno actividad de la vaca ultimas 24 horas
      actividades_prom[n] = 0 #almeceno act promedio de todas las vacas

      #actividad de la vaca
      actividad = vaca.actividades.where("tipo = 'recorrido' AND 
        registrada >= ? and registrada < ?", hora_start,hora_end).first

      #actividad promedio del ganado de la hora en analisis
      actividad_promedio = Actividad.where("tipo = 'promedio' AND 
            registrada >= ? and registrada < ?", hora_start,hora_end).first
      
      if !actividad.nil?       
        actividades_vc[n] = actividad.valor
        if !actividad_promedio.nil?       
          actividades_prom[n] = actividad_promedio.valor
        end
      end      
    end
    return actividades_vc, actividades_prom
  end

  #PASAR A OTRO ARCHIVO (track_stats)
  # crea la actividad promedio de cada hora
def crear_actividad_promedio
    24.times do |n|
      hora = Time.now.advance(:hours => (-24+n).to_i).localtime
      hora_start = hora.change(:min => 0)      
      actividad_promedio = actividad_promedio(hora_start)   
      Actividad.create!(vaca_id: 0,registrada: hora_start, tipo: "promedio", valor: actividad_promedio)     
    end
end


def actividad_promedio(momento)
   from = momento.advance(:minutes => -10) 
   to   = momento.advance(:minutes => 10) 
   actividades = Actividad.where("registrada between ? and ? and tipo = ?", from,to,'recorrido')
   actividad_promedio = 0

   #no considero vacas con actividad=0 en el promedio
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

#temporal, para simular aumento de actividad de vaca en celo
def actividad_celo(vaca)
    momento_celo_start = 12.hours.ago.localtime
    momento_celo_start = momento_celo_start.change(:min => 0)
    momento_celo_end = 6.hours.ago.localtime
    actividad_celo = vaca.actividades.where("tipo = 'recorrido' AND registrada between ? and ? ", momento_celo_start,momento_celo_end)
    
    actividad_celo.each do |actividad|
      actividad.valor = (actividad.valor) * 2.0
      actividad.save
    end
end

end