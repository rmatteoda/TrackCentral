  
  namespace :db do
  desc "Fill database with sample data"
  
  #limppiar la base rake db:purge
  task populate: :environment do
    Rake::Task['db:reset'].invoke
    populate_usuarios
    populate_vacas(17,1)
    populate_nodos(17,101)
    align_vacas_nodos(17,1,101)
    #populate_alert_data(18)
    populate_celos
    #Rake::Task['track_celo:simular_celos'].invoke
    Rake::Task['track_stats:generar_recorrido_promedio'].invoke  
    Rake::Task['track_celo:detectar_celos'].invoke
  end

  task populate_basic: :environment do
    Rake::Task['db:reset'].invoke
    populate_usuarios
    populate_vacas(75,1)
    populate_nodos(75,101)
    align_vacas_nodos(75,1,101)
  end

  task agregar_vacas: :environment do
    populate_vacas(2,8)
    populate_nodos(2,109)
    align_vacas_nodos(2,8,109)
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
        populate_actividades(vaca,18,24)
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
      celo_start = celo_start.change(:min => 0)
      vaca.celos.create!(comienzo: celo_start,
                          probabilidad: "alta",
                          caravana: vaca.caravana,
                          causa: "aumento de actividad")
      vaca.sucesos.create!(momento: celo_start, tipo: "celo")
      end
   end

  def populate_nodos (num_nodos,id_inicio)
    num_nodos.times do |n|
      nodo = (n + id_inicio.to_i).to_s 
      Nodo.create!(nodo_id: nodo,
                  bateria: 100)   
    end
  end

  def populate_actividades(vaca,hr_inicio,n_act)
    inicio = hr_inicio.hours.ago.localtime
    n_act.times do |n|
      registro = inicio.advance(:hours => n)
      registro_hr = registro.to_datetime.change(:min => 0)
      value = rand_int(100,120)    
      vaca.actividades.create!(registrada: registro_hr, tipo: "recorrido", valor: value)
    end 
  end

  def populate_sucesos(vaca)     
    #inicio = 3.months.ago
    #vaca.sucesos.create!(momento: inicio, tipo: "parto")
  
    #inicio = 30.days.ago
    #vaca.sucesos.create!(momento: inicio, tipo: "inseminada")
  end

  def align_vacas_nodos(num_elem,id_vaca_inicio,id_nodo_inicio)
    num_elem.times do |n|
      ind_vaca = n + id_vaca_inicio.to_i
      ind_nodo = n + id_nodo_inicio.to_i
      nodo_id = ind_nodo.to_s
      caravana = ind_vaca.to_s
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

  def populate_alert_data(id_vaca)
    vaca = Vaca.create!(caravana: id_vaca,
                   raza: "Holando",
                   estado: "Normal")        
    ultimo_parto = 125.days.ago
    vaca.sucesos.create!(momento: ultimo_parto, tipo: "parto")
  
    inicio = 50.days.ago
    vaca.sucesos.create!(momento: inicio, tipo: "servicio")
    
    inicio = 30.days.ago
    vaca.sucesos.create!(momento: inicio, tipo: "servicio")
  end

end