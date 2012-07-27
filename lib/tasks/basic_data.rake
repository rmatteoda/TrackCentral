namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
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
    14.times do |n|
        cv = n.to_i + 1
        vaca = Vaca.create!(caravana: cv,
                   raza: "Holando",
                   estado: "Normal") 
        populate_actividades(vaca)
    end
  end

  def populate_nodos
    14.times do |n|
      nodo = "ND_" + (n+1).to_s 
      Nodo.create!(nodo_id: nodo,
                  bateria: 100)   
    end
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

  def populate_actividades(vaca)
    inicio = 4.days.ago
    48.times do |n|
      registro = inicio.advance(:hours => 2*n)
      value = rand_int(50,70)    
      #value = rand_int(100,120) if n>3  
      vaca.actividades.create!(registrada: registro, tipo: "recorrido", valor: value)
    end 
  end

  def rand_int(from, to)
  (rand * (to - from) + from).to_i
  end
end