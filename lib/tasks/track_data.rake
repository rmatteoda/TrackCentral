namespace :track_data do
  desc "Task para generar dato que vendra del colector"
  #Rake::Task['morning:make_coffee'].invoke
      
  task create_demo_data: :environment do
    File.open('./public/data_from_collector.txt', 'a+') do |f|     
      registro = Time.now.to_datetime
      vacas = Vaca.all
      vacas.each do |vaca|
      	value = (rand * (150 - 180) + 180).to_i
      	if !vaca.nodo_id.nil?
        	f.puts vaca.nodo_id.to_s + "," + rand_int(150, 180).to_s + "," + registro.to_s
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

end