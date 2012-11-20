namespace :track_data do
  desc "Task para leer datos que vendran del colector"
  #Rake::Task['morning:make_coffee'].invoke
      
  task create_demo_data: :environment do
    File.open('./public/data_from_collector_t.txt', 'a+') do |f|     
      registro = Time.now.to_datetime
      vacas = Vaca.all
      vacas.each do |vaca|
      	value = (rand * (50 - 80) + 80).to_i
      	if !vaca.nodo_id.nil?
        	f.puts vaca.nodo_id.to_s + "," + rand_int(50, 80).to_s + "," + registro.to_s
    	end
      end
      f.puts "#end_data\n"
    end
  end

  task read_demo_data: :environment do
    data_file = File.open('./public/data_from_collector.txt', 'r')      
      
    while (line = data_file.gets)
       data = line.split(',')
       if data.length >= 3
       	save_activity(data[0],data[1],data[2])
       end
    end
    
    File.delete('./public/data_from_collector.txt')    
  end

  task load_collected_data: :environment do

    File.open('/home/tracktambo/TrackCentral/log/data_collected_log.txt', 'a+') do |f|     
      
    if File.exist?('/home/tracktambo/TrackCentral/public/data_from_collector.txt')
   
    data_file = File.open('/home/tracktambo/TrackCentral/public/data_from_collector.txt', 'r')      
    data_file.flock(File::LOCK_EX)
    all_lines = data_file.readlines
    #data_file.flock(File::LOCK_UN)
    File.delete('/home/tracktambo/TrackCentral/public/data_from_collector.txt')
    
    current_vaca = nil
    last_register = nil
    f.puts "loaded " + all_lines.length.to_s + " " + DateTime.now.to_s+"\n "
         
    all_lines.each do |line|
      data = line.split(',')
       if data[0].to_s.eql? "Start"
         #f.puts "busca vaca " + data[1].to_s + " \n "
         vacas = Vaca.where("nodo_id = ?",data[1].to_s)
         if vacas.any?
         #f.puts "encontro vaca " + vacas.first.id.to_s + " \n "
          current_vaca = vacas.first 
          last_activity = current_vaca.actividades.last
          last_register = last_activity.registrada
         end
        elsif data.length >= 4
           #f.puts "voy a guarder " + current_vaca.id.to_s + " \n "
           if !current_vaca.nil? && !last_register.nil?
            last_register = last_register.advance(:hours => 1)
            save_collected_activity(current_vaca,data[0],data[1],data[2],data[3],last_register)
          end
        end
    end
    
    end
    
    end 
  end

  task simulate_demo_data: :environment do
      registro = Time.now.to_datetime
      vacas = Vaca.all
      vacas.each do |vaca|
        value = (rand * (50 - 80) + 80).to_i
        if !vaca.nodo_id.nil?
          save_activity(vaca.nodo_id.to_s,value,registro.to_s)
        end
      end
  end
  
####################### PRIVATE METHODS ################
private
  def save_activity(nodo_id,eventos,registro)
  	#puts "guardo " + nodo_id.to_s + " - " + eventos.to_s
  	vacas = Vaca.where("nodo_id = ?",nodo_id)
  	if vacas.any?
  		vaca_selected = vacas.first
  		vaca_selected.actividades.create!(registrada: registro, tipo: "recorrido", valor: eventos)
  	end
  end

  def save_collected_activity(vaca,accel_slow,accel_medium,accel_fast,accel_cont,registro)
      #puts "guardo " + vaca.nodo_id.to_s + " - " + accel_slow.to_s + " - " + registro.to_s

      vaca_selected = vaca
      vaca_selected.actividades.create!(registrada: registro, tipo: "recorrido_lento", 
                                        valor: accel_slow)
      vaca_selected.actividades.create!(registrada: registro, tipo: "recorrido_medio", 
                                        valor: accel_medium)
      vaca_selected.actividades.create!(registrada: registro, tipo: "recorrido_rapido", 
                                        valor: accel_fast)
      vaca_selected.actividades.create!(registrada: registro, tipo: "recorrido_continuo", 
                                        valor: accel_cont)
  end

end