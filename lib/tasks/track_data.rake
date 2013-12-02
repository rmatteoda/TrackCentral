namespace :track_data do
  desc "Task para leer datos del colector"
      
   task load_collected_data: :environment do

    if File.exist?('public/data_from_collector.txt')
      #open file, save into array and move file for register
      data_file = File.open('public/data_from_collector.txt', 'r')      
      all_lines = data_file.readlines
      data_file.close
      FileUtils.cp("public/data_from_collector.txt", "public/" + Time.now.strftime("%Y%m%d-%H_%M").to_s + "_data_from_collector.txt")
      
      current_vaca = nil
      last_register = nil
      initial_hr_dump = nil
      n_dumps = 0

      all_lines.each do |line|
        data = line.split(',')
          
        if data[0].to_s.eql? "Start"
         vacas = Vaca.where("nodo_id = ?",data[1].to_s)
         if vacas.any?
          current_vaca = vacas.first 
          last_activity = current_vaca.actividades.last
          last_register = last_activity.registrada
         end
        elsif data.length >= 4 #TODO cambiar condicion
          if !current_vaca.nil? && !last_register.nil?
            save_collected_events(current_vaca,data,last_register)
            n_dumps = n_dumps + 1
          end
        end
      end
      
      if n_dumps > 2
        system "bundle exec rake track_celo:detectar_celos"
      end
    end    
  end
  
####################### PRIVATE METHODS ################
private
  
  def save_collected_events(vaca,events,last_register)
      num_horas = (events.length / 2)
      reg_actividad = registro_inicio(vaca,num_horas)
      
      vaca_selected = vaca
      ev_ind = 0

      num_horas.times do
        clean_actividades(vaca,reg_actividad)

        vaca_selected.actividades.create!(registrada: reg_actividad, 
          tipo: "recorrido",valor: events[ev_ind])
        vaca_selected.actividades.create!(registrada: reg_actividad, 
          tipo: "recorrido_nivelado",valor: events[ev_ind+1])
  
        reg_actividad = reg_actividad.advance(:hours => 1).to_datetime
        ev_ind = ev_ind + 2
      end
  end
  
  #calculo la hora de inicio de actividad de acuerdo a la cantidad descargada
  def registro_inicio(vaca,num_horas)
    estim_reg = Time.now.advance(:hours => -num_horas.to_i).localtime
    estimate_time = estim_reg.change(:min => 0)
    return estimate_time      
  end

  #elimino actividades si existen con registro posterior a la hora calculada
  def clean_actividades(vaca,reg_actividad)
    from = reg_actividad.advance(:minutes => -10).localtime        
    act_tot_reg = vaca.actividades.where("registrada >= ? and tipo = ?", from,'recorrido')
    if act_tot_reg.any?
      act_tot_reg.destroy_all
    end     
  end

end