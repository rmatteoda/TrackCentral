namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
   
    admin = User.create!(name: "Administrador",
                 email: "admin@tracktambo.com",
                 password: "admin",
                 password_confirmation: "admin")
    admin.toggle!(:admin)
    User.create!(name: "Ramiro",
                 email: "ramiro@tracktambo.com",
                 role: "encargado",
                 password: "ramiro",
                 password_confirmation: "ramiro")
  end
end