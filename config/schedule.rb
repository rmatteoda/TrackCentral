# Example:
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# Learn more: http://github.com/javan/whenever

every :reboot do
  #start server, start GUI, check all, registrar alarma
end

every 2.hours do
  #controlar y almacenar info de actividad en la DB. ActivityCoreSave
end

every 6.hours do
  #controlar y detectar vacas en celo ActivityCeloDetect
end

every 2.days, :at => '2:30 am' do
  #ActivityCollarController? puede hacerlo el colector
end

every 10.days do
  #detectar problemas, vacas con muchos servicios, >130dias no preñada. ActivityVacasObserver
  rake "track_vacas:detectar_alarmas"
end

every 90.days, :at => '2:00 am' do
  #borrar registro de actividades con mas de 1 mes de antiguedad ActivityClearDB
  rake "track_db:clear_old_data"
end
