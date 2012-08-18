namespace :track_db do
  desc "Task para mentenimiento de informacion en la DB"
  #Rake::Task['morning:make_coffee'].invoke
      
  task clear_old_data: :environment do
   #eliminar actividades con mas de 30 dias de antiguedad
   Actividad.destroy_all(["registrada <= ?", 3.days.ago])
  
  end
end