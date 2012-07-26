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
        Vaca.create!(caravana: cv,
                   raza: "Holando",
                   estado: "Normal") 
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
end