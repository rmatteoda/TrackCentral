  
  namespace :db do
  desc "Fill database with sample data"
  
  #limppiar la base rake db:purge
  task populate: :environment do
    populate_usuarios
    populate_vacas
    populate_nodos
    align_vacas_nodos
    populate_alert_data
    Rake::Task['track_vacas:detectar_alarmas'].invoke
    Rake::Task['track_celo:simular_celos'].invoke
    Rake::Task['track_celo:detectar_celos'].invoke
  end

  task populate_basic: :environment do
    populate_usuarios
    populate_vacas(7,1)
    populate_nodos(7,101)
    align_vacas_nodos(7,1,101)
    populate_celos
  end

  task agregar_vacas: :environment do
    populate_vacas(2,8)
    populate_nodos(2,109)
    align_vacas_nodos(2,8,109)
    #populate_celos
  end
  
  task eliminar_vacas: :environment do
    delete_vacas(25,25)   
  end

  def populate_usuarios
    admin = User.create!(name: "Administrador",
                 email: "admin@tracktambo.com",
                 password: "admin",
                 password_confirmation: "admin")
    admin.toggle!(:admin)
    User.create!(name: "Ramiro",
                 email: "rm@tracktambo.com",
                 role: "Encargado",
                 password: "ramiro",
                 password_confirmation: "ramiro")
  end

  def populate_vacas (num_vacas,id_inicio)
    num_vacas.times do |n|
        cv = n.to_i + id_inicio.to_i
        vaca = Vaca.create!(caravana: cv,
                   raza: "Holando",
                   rodeo: 1,
                   estado: "Normal") 
        populate_actividades(vaca)
        populate_sucesos(vaca)
    end
  end

  def delete_vacas (num_vacas,id_inicio)
    num_vacas.times do |n|
      cv = n.to_i + id_inicio.to_i
      @vaca = Vaca.find(cv)
      @vaca.nodo = nil
      @vaca.destroy        
    end
  end

   def populate_celos
      @vacas = Vaca.all
      @vacas.each do |vaca|
       celo_start = (19+vaca.id).days.ago.to_datetime
       vaca.celos.create!(comienzo: celo_start,
                          probabilidad: "alta",
                          caravana: vaca.caravana,
                          causa: "aumento de actividad")
      end

      celo_start = Time.now.to_datetime
      vaca = Vaca.find(5)
      vaca.celos.create!(comienzo: celo_start,
                          probabilidad: "alta",
                          caravana: vaca.caravana,
                          causa: "aumento de actividad")
   end


  def populate_nodos (num_nodos,id_inicio)
    num_nodos.times do |n|
      nodo = (n + id_inicio.to_i).to_s 
      Nodo.create!(nodo_id: nodo,
                  bateria: 100)   
    end
  end

  def populate_actividades(vaca)
    inicio = 18.hours.ago
    #8.times do |n|
     # registro = inicio.advance(:hours => n)
      #registro_hr = DateTime.new(registro.year, registro.month, registro.day, 
      #  registro.hour, 0, 0, 0)
      registro_hr = DateTime.new(Time.now.year, Time.now.month, Time.now.day, 
        (Time.now.hour-1), 0, 0, 0)
      
      value = rand_int(1,2)    
      vaca.actividades.create!(registrada: registro_hr, tipo: "recorrido", valor: value)
      vaca.actividades.create!(registrada: registro_hr, tipo: "recorrido_total", valor: value)
      vaca.actividades.create!(registrada: registro_hr, tipo: "recorrido_nivelado", valor: value)
    #end 
  end

  def populate_sucesos(vaca)
    inicio = 26.months.ago
    vaca.sucesos.create!(momento: inicio, tipo: "servicio")
    
    inicio = 16.months.ago
    vaca.sucesos.create!(momento: inicio, tipo: "parto")
    
    inicio = 14.months.ago
    vaca.sucesos.create!(momento: inicio, tipo: "servicio")
 
    inicio = 13.months.ago
    vaca.sucesos.create!(momento: inicio, tipo: "servicio")
        
    inicio = 3.months.ago
    vaca.sucesos.create!(momento: inicio, tipo: "parto")
  
    inicio = 20.days.ago
    vaca.sucesos.create!(momento: inicio, tipo: "servicio")
  end

  def populate_alert_data
    vaca = Vaca.create!(caravana: 6,
                   raza: "Holando",
                   estado: "Normal") 
        
    ultimo_parto = 125.days.ago
    vaca.sucesos.create!(momento: ultimo_parto, tipo: "parto")
  
    inicio = 50.days.ago
    vaca.sucesos.create!(momento: inicio, tipo: "servicio")
    
    inicio = 30.days.ago
    vaca.sucesos.create!(momento: inicio, tipo: "servicio")
  
    inicio = 15.days.ago
    vaca.sucesos.create!(momento: inicio, tipo: "servicio")
  
    inicio = 1.days.ago
    vaca.sucesos.create!(momento: inicio, tipo: "servicio") 
  end


  def align_vacas_nodos(num_elem,id_vaca_inicio,id_nodo_inicio)
    num_elem.times do |n|
      ind = n + id_vaca_inicio.to_i
      ind2 = n + id_nodo_inicio.to_i
      nodo_id = ind2.to_s
      caravana = ind.to_s
      nodo = Nodo.where("nodo_id = ?",nodo_id).first
      vaca = Vaca.where("caravana = ?",caravana).first
      vaca.nodo_id = nodo_id
      vaca.nodo = nodo
      vaca.save
    end
  end

  def rand_int(from, to)
  (rand * (to - from) + from).to_i
  end

end