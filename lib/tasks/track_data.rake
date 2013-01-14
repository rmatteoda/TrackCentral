namespace :track_data do
  desc "Task para leer datos que vendran del colector"
  #Rake::Task['morning:make_coffee'].invoke
      
   task load_collected_data: :environment do

    #data_file.flock(File::LOCK_UN)
    #f.puts "loaded " + all_lines.length.to_s + " " + DateTime.now.to_s+"\n "
    #data_file.flock(File::LOCK_UN)
    
    File.open('./log/data_collected_log.txt', 'a+') do |f|     
    
    if File.exist?('public/data_from_collector.txt')
   
    data_file = File.open('public/data_from_collector.txt', 'r')      
    data_file.flock(File::LOCK_EX)
    all_lines = data_file.readlines
    data_file.close
    #FileUtils.cp("public/data_from_collector.txt", "public/" + Time.now.strftime("%Y%m%d-%H:%M") + "_data_from_collector.txt")
    #File.unlink('./public/data_from_collector.txt')
    f.puts "loaded " + all_lines.length.to_s + " " + DateTime.now.to_s+"\n "
    
    current_vaca = nil
    last_register = nil
    initial_hr_dump = nil
         
    all_lines.each do |line|
      data = line.split(',')
        
        if data[0].to_s.eql? "Start"
         vacas = Vaca.where("nodo_id = ?",data[1].to_s)
         initial_hr_dump = data[2].to_i
         if vacas.any?
          current_vaca = vacas.first 
          last_activity = current_vaca.actividades.last
          last_register = last_activity.registrada
         end
        elsif data.length >= 4 #TODO cambiar condicion
           if !current_vaca.nil? && !last_register.nil?
            save_collected_events(current_vaca,data,last_register,initial_hr_dump)
          end
        end
    end  
    end
    end 
  end
  
####################### PRIVATE METHODS ################
private
  
  def save_collected_events(vaca,events,last_register,initial_hr_dump)
      num_horas = (events.length / 2)
      reg_actividad = registro_inicio(vaca,last_register,num_horas,initial_hr_dump)
      
      vaca_selected = vaca
      ev_ind = 0
      num_horas.times do
        vaca_selected.actividades.create!(registrada: reg_actividad, 
          tipo: "recorrido_total",valor: events[ev_ind])
        vaca_selected.actividades.create!(registrada: reg_actividad, 
          tipo: "recorrido_nivelado", valor: events[ev_ind+1])

        reg_actividad = reg_actividad.advance(:hours => 1)
        ev_ind = ev_ind + 2
      end
  end

  def registro_inicio(vaca,ultimo_registro,num_horas,initial_hr_dump)
    estim_reg = Time.now.advance(:hours => -num_horas.to_i)
    estimate_time = Time.new(estim_reg.year, estim_reg.month, estim_reg.day, 
      estim_reg.hour, 0, 0, 0)
    
    diff_hr_estimate = ((estimate_time - ultimo_registro)/3600).to_i
    diff_hr_initial = initial_hr_dump.to_i - ultimo_registro.hour.to_i
    diff_initial_estimate = estimate_time.hour - initial_hr_dump
    estimate_to_initial = Time.new(estimate_time.year, estimate_time.month, estimate_time.day, 
      initial_hr_dump, 0, 0, 0)

    estimate_time.advance(:hours => -diff_initial_estimate)
    
    #puts "ultimo reg  : " + ultimo_registro.to_s
    #puts "estimado : " + estimate_time.to_s
    #puts "estimado inicial : " + estimate_to_initial.to_s
    #puts "dif estimado inicial : " + diff_initial_estimate.to_s
    #puts "dif hr estimado  : " + diff_hr_estimate.to_s

    #TODO agregar log de errores en este metodo
    if diff_hr_estimate <= 0
      return ultimo_registro.advance(:hours => 1)
    end

    if diff_hr_estimate <= 3 
      if diff_hr_initial == 1
        return ultimo_registro.advance(:hours => 1)
      else
        completar_horas_noreg(vaca,ultimo_registro,estimate_time)
        return estimate_time
      end
    else
      if diff_initial_estimate < 0 || diff_initial_estimate > 3
        completar_horas_noreg(vaca,ultimo_registro,estimate_time)
        return estimate_time
      else
        completar_horas_noreg(vaca,ultimo_registro,estimate_to_initial)
        return estimate_to_initial 
      end
    end
  end

  def completar_horas_noreg(vaca,ultimo_reg,proximo_reg)
   diff_hr_estimate = (((proximo_reg - ultimo_reg)/3600).to_i - 1)
   reg_actividad = ultimo_reg.advance(:hours => 1)
    #puts "proximo " + proximo_reg.to_s
    #puts "ultimo " + ultimo_reg.to_s

    diff_hr_estimate.times do
        vaca.actividades.create!(registrada: reg_actividad, 
          tipo: "recorrido_total",valor: -1)
        vaca.actividades.create!(registrada: reg_actividad, 
          tipo: "recorrido_nivelado", valor: -1)
    #    puts "cargo -1 a " + reg_actividad.to_s
        reg_actividad = reg_actividad.advance(:hours => 1)
    end

  end
        

  def save_collected_activity(vaca,accel_slow,accel_medium,accel_fast,accel_cont,registro)
      act_total = accel_slow.to_i + accel_medium.to_i + accel_fast.to_i + accel_cont.to_i

      registro_hr = DateTime.new(registro.year, registro.month, registro.day, registro.hour, 0, 0, 0)

      vaca_selected = vaca
      vaca_selected.actividades.create!(registrada: registro_hr, tipo: "recorrido_lento", 
                                        valor: accel_slow)
      vaca_selected.actividades.create!(registrada: registro_hr, tipo: "recorrido_medio", 
                                        valor: accel_medium)
      vaca_selected.actividades.create!(registrada: registro_hr, tipo: "recorrido_rapido", 
                                        valor: accel_fast)
      vaca_selected.actividades.create!(registrada: registro_hr, tipo: "recorrido_continuo", 
                                        valor: accel_cont)
      vaca_selected.actividades.create!(registrada: registro_hr, tipo: "recorrido_total", 
                                        valor: act_total)
  end

end