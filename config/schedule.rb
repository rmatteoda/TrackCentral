# Learn more: http://github.com/javan/whenever

every :reboot do
  #re-start server, start GUI, check all, registrar alarma
  #rake "track_system:stop_server"
  command "cd /Users/ramiro/Workspace/workspace_ror/TrackCentral && RAILS_ENV=:environment && ruby script/rails s -p 3020"
  rake "track_system:open_gui", :output => {:error => 'track_gui_error.log', :standard => 'track_gui_cron.log'}
  rake "track_system:start_server", :output => {:error => 'track_error.log', :standard => 'track_cron.log'}
  #command "cd /Users/ramiro/Workspace/workspace_ror/TrackCentral && RAILS_ENV=:environment && ruby script/rails s -p 3020"
end

every 30.days, :at => '1:30 am' do #???
  #re-start server, start GUI
  #rake "track_system:stop_server"
  #rake "track_system:start_server"
  #rake "track_system:close_gui"
  #rake "track_system:open_gui"
  #clear cache?
end

every 1.hours do
  #generar archivo de datos para test
  rake "track_data:create_demo_data"
end

every 2.hours do
  #almacenar info de actividad en la DB. ActivityCoreSave
  rake "track_data:read_demo_data"
end

every 1.days, :at => '8:30 am' do #???
  #generar vacas en celo aumentando actividad a 3 elejidas al azar
  rake "track_data:simular_celos"
end

every 6.hours do
  #controlar y detectar vacas en celo ActivityCeloDetect
end

every 2.days, :at => '2:30 am' do
  #controlar si no se perdio algun collar
  rake "track_vacas:detectar_perdida"
end

every 10.days do
  #detectar problemas, vacas con muchos servicios, >130dias no preñada. Collar con bateria baja
  rake "track_vacas:detectar_alarmas"
end

every 90.days, :at => '2:00 am' do
  #borrar registro de actividades con mas de 1 mes de antiguedad ActivityClearDB
  rake "track_db:clear_old_data"
end
