# Learn more: http://github.com/javan/whenever

#every 30.days, :at => '1:30 am' do #???
  #rake "track_system:restart_system"
  #clear cache?
#end

#every 1.hours do
  #generar archivo de datos para test
  #rake "track_data:create_demo_data"
#end

#every 2.hours do
  #almacenar info de actividad en la DB. ActivityCoreSave
  #rake "track_data:read_demo_data"
#end

#every 1.days, :at => '8:30 am' do #???
  #generar vacas en celo aumentando actividad a 3 elejidas al azar
  #rake "track_celo:simular_celos"
#end

#every 6.hours do
  #controlar y detectar vacas en celo ActivityCeloDetect
  #rake "track_celo:detectar_celos"
#end

#every 2.days, :at => '2:30 am' do
  #controlar si no se perdio algun collar
  #rake "track_vacas:detectar_perdida"
#end

#every 10.days do
  #detectar problemas, vacas con muchos servicios, >130dias no preñada. Collar con bateria baja
  #rake "track_vacas:detectar_alarmas"
#end

#every 90.days, :at => '2:00 am' do
  #borrar registro de actividades con mas de 1 mes de antiguedad ActivityClearDB
  #rake "track_db:clear_old_data"
#end
