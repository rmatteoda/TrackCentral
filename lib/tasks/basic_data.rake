namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    populate_usuarios
    populate_vacas
    populate_nodos
    align_vacas_nodos
    populate_alarmas
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
    14.times do |n|
        cv = n.to_i + 1
        vaca = Vaca.create!(caravana: cv,
                   raza: "Holando",
                   estado: "Normal") 
        populate_actividades(vaca)
        populate_sucesos(vaca)
    end
  end

  def populate_nodos
    14.times do |n|
      nodo = "ND_" + (n+1).to_s 
      Nodo.create!(nodo_id: nodo,
                  bateria: 100)   
    end
  end

  def populate_alarmas
    registro = 2.hours.ago
    Alarma.create!(vaca_id: 5,
                  horas_de_valides: 18,
                  tipo: "celo_detectado",
                  vista: false,
                  registrada: registro)   

    registro = 2.days.ago
    Alarma.create!(vaca_id: 7,
                  tipo: "servicios",
                  vista: false,
                  registrada: registro)   
 
    registro = 2.days.ago
    Alarma.create!(vaca_id: 4,
                  tipo: "post-parto",
                  vista: false,
                  registrada: registro)   
 end

  def populate_actividades(vaca)
    inicio = 4.days.ago
    48.times do |n|
      registro = inicio.advance(:hours => 2*n)
      value = rand_int(50,70)    
      if (vaca.caravana >= 3 && vaca.caravana < 5 && n>=40 && n<44)
        value = rand_int(130,150)
      end
      vaca.actividades.create!(registrada: registro, tipo: "recorrido", valor: value)
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


  def align_vacas_nodos
    14.times do |n|
      ind = n+1
      nodo_id = "ND_" + ind.to_s
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