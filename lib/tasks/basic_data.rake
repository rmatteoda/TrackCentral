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
    populate_vacas
    populate_nodos
    align_vacas_nodos
  end

  def populate_usuarios
    admin = User.create!(name: "Administrador",
                 email: "admin@tracktambo.com",
                 password: "admin",
                 password_confirmation: "admin")
    admin.toggle!(:admin)
    User.create!(name: "Cesar",
                 email: "cesar@tracktambo.com",
                 role: "Encargado",
                 password: "cesar",
                 password_confirmation: "cesar")
  end

  def populate_vacas
    5.times do |n|
        cv = n.to_i + 1
        vaca = Vaca.create!(caravana: cv,
                   raza: "Holando",
                   estado: "Normal") 
        populate_actividades(vaca)
        populate_sucesos(vaca)
    end
  end

  def populate_nodos
    5.times do |n|
      #nodo = "ND_" + (n+1).to_s 
      nodo = (n + 101).to_s 
      Nodo.create!(nodo_id: nodo,
                  bateria: 100)   
    end
  end

  def populate_actividades(vaca)
    #inicio = 2.days.ago
    inicio = 2.hours.ago
    #48.times do |n|
    2.times do |n|
      registro = inicio.advance(:hours => n)
      value = rand_int(6,7)    
      vaca.actividades.create!(registrada: registro, tipo: "recorrido", valor: value)
      value = rand_int(6,7)    
      vaca.actividades.create!(registrada: registro, tipo: "recorrido_lento", valor: value)
      value = rand_int(4,5)    
      vaca.actividades.create!(registrada: registro, tipo: "recorrido_medio", valor: value)
      value = rand_int(3,2)    
      vaca.actividades.create!(registrada: registro, tipo: "recorrido_rapido", valor: value)
      value = rand_int(2,1)    
      vaca.actividades.create!(registrada: registro, tipo: "recorrido_continuo", valor: value)
    end 
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
    #populate_actividades(vaca)
        
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


  def align_vacas_nodos
    5.times do |n|
      ind = n+1
      ind2 = n+101
      #nodo_id = "ND_" + ind.to_s
      nodo_id = ind2.to_s
      nodo = Nodo.where("nodo_id = ?",nodo_id).first
      vaca = Vaca.find(ind.to_i)
      vaca.nodo_id = nodo_id
      vaca.nodo = nodo
      vaca.save
    end
  end

  def rand_int(from, to)
  (rand * (to - from) + from).to_i
  end

end